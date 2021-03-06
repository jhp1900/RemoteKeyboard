#include <iostream>
#include <QDebug>
#include "comm.h"

Comm::Comm()
    : keep_sock_(INVALID_SOCKET)
    , action_sock_(INVALID_SOCKET)
    , is_connected_(FALSE)
    , send_event_(NULL)
{
    send_event_ = CreateEvent(NULL, TRUE, FALSE, NULL);
}

Comm::~Comm()
{
    Stop();

    if (kelv_thread_.joinable())
        kelv_thread_.join();
    if (send_thread_.joinable())
        send_thread_.join();
    if (recv_thread_.joinable())
        recv_thread_.join();

    CloseHandle(send_event_);
    closesocket(keep_sock_);
    closesocket(action_sock_);
    WSACleanup();
}

BOOL Comm::ConnectServer(const char * ip, int port)
{
    WSADATA wsd;
    if (WSAStartup(MAKEWORD(2, 2), &wsd) != 0)
        return FALSE;
    if ((keep_sock_ = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
        return FALSE;
    if ((action_sock_ = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
        return FALSE;

    unsigned long ul = 1;
    if (ioctlsocket(keep_sock_, FIONBIO, &ul) == SOCKET_ERROR)
        return FALSE;
    if (ioctlsocket(action_sock_, FIONBIO, &ul) == SOCKET_ERROR)
        return FALSE;

    sockaddr_in sv_addr;
    sv_addr.sin_family = AF_INET;
    sv_addr.sin_addr.S_un.S_addr = inet_addr(ip);
    sv_addr.sin_port = htons(port);

    int reVal;
    int conn_count = 10;
    while (--conn_count) {
        reVal = ::connect(keep_sock_, (SOCKADDR*)&sv_addr, sizeof(sv_addr));
        if (reVal == SOCKET_ERROR) {
            int err_code = WSAGetLastError();
            if (err_code == WSAEWOULDBLOCK || err_code == WSAEINVAL) {
                Sleep(TIMEFOR_THREAD_CONTINUE);
                continue;
            }
            else if (err_code == WSAEISCONN)
                break;
            else
                return FALSE;
        }
        if (reVal == 0)
            break;
    }
    conn_count = 10;
    while (--conn_count) {
        reVal = ::connect(action_sock_, (SOCKADDR*)&sv_addr, sizeof(sv_addr));
        if (reVal == SOCKET_ERROR) {
            int err_code = WSAGetLastError();
            if (err_code == WSAEWOULDBLOCK || err_code == WSAEINVAL) {
                Sleep(TIMEFOR_THREAD_CONTINUE);
                continue;
            }
            else if (err_code == WSAEISCONN) {
                is_connected_ = TRUE;
                return TRUE;
            }
            else
                return FALSE;
        }
        if (reVal == 0) {
            is_connected_ = TRUE;
            return TRUE;
        }
    }

    is_connected_ = FALSE;
    return FALSE;
}

BOOL Comm::DisconnectServer()
{
    is_connected_ = FALSE;
    return TRUE;
}

BOOL Comm::RunClient()
{
    kelv_thread_ = std::thread(KeepLiveFun, this);
    send_thread_ = std::thread(SendThreadFun, this);
    recv_thread_ = std::thread(RecvThreadFun, this);
    return TRUE;
}

void Comm::SendData(const char * data)
{
    send_str_ = data;
    SetEvent(send_event_);
}

WINBOOL Comm::Stop()
{
    is_connected_ = false;
}

void Comm::KeepLiveFun(void *param)
{
    int i = 10;
    Comm * comm = (Comm*)param;
    while (comm->is_connected_) {
        comm->send_mutex_.lock();
        while (i--) {
            int val = send(comm->keep_sock_, "KEEPLIVE", 10, 0);
            if (val == SOCKET_ERROR) {
                int err_code = WSAGetLastError();
                if (err_code == WSAEWOULDBLOCK)
                    continue;
                else
                    return;
            }
            break;
        }
        comm->send_mutex_.unlock();
        Sleep(TIMEFOR_THREAD_SLEEP);
    }

    qDebug() << " @ @ The KeepLive Thread Is Over ! ! ! \n\n";
}

void Comm::SendThreadFun(void * param)
{
    Comm * comm = (Comm*)param;
    while (comm->is_connected_) {
        if (WAIT_OBJECT_0 == WaitForSingleObject(comm->send_event_, INFINITE)) {
            comm->send_mutex_.lock();
            while (true) {
                int val = send(comm->action_sock_, comm->send_str_.c_str(), comm->send_str_.length(), 0);
                if (val == SOCKET_ERROR) {
                    int err_code = WSAGetLastError();
                    if (err_code == WSAEWOULDBLOCK) {
                        continue;
                    }
                    else {
                        ResetEvent(comm->send_event_);
                        return;
                    }
                }
                qDebug() << "Send Msg : " << QString(QLatin1String(comm->send_str_.c_str()));
                ResetEvent(comm->send_event_);
                break;
            }
            comm->send_mutex_.unlock();
        }
    }

    qDebug() << " $ $ The Send Thread Is Over ! ! ! \n\n";
}

void Comm::RecvThreadFun(void * param)
{
    Comm * comm = (Comm*)param;
    int val;
    char temp[BUF_MAX_NUM];
    memset(temp, 0, BUF_MAX_NUM);
    while (comm->is_connected_) {
        val = recv(comm->keep_sock_, temp, BUF_MAX_NUM, 0);
        if (val == SOCKET_ERROR) {
            int err_code = WSAGetLastError();
            if (err_code == WSAEWOULDBLOCK) {
                Sleep(TIMEFOR_THREAD_CONTINUE);
                continue;
            }
            else {
                comm->is_connected_ = FALSE;
                return;
            }
        }

        if (val == 0) {
            comm->is_connected_ = FALSE;
            return;
        }

        if (val > 0) {
            emit comm->recvPack(QString(QLatin1String(temp)));
            memset(temp, 0, BUF_MAX_NUM);
        }
        Sleep(TIMEFOR_THREAD_SLEEP);
    }

    qDebug() << " # # The Recv Thread Is Over ! ! ! \n\n";
}
