#ifndef COMM_H
#define COMM_H

#include <WinSock2.h>
#include <QObject>
#include <QString>
#include <thread>
#include <mutex>
#include <string>

#define  TIMEFOR_THREAD_CONTINUE 50
#define  TIMEFOR_THREAD_SLEEP 500
#define  BUF_MAX_NUM 1024 * 2

class Comm : public QObject
{
    Q_OBJECT
public:
    Comm();
    ~Comm();

    BOOL ConnectServer(const char * ip, int port);
    BOOL DisconnectServer();
    BOOL RunClient();
    void SendData(const char * data);
    BOOL Stop();

public:
    static void KeepLiveFun(void *param);
    static void SendThreadFun(void *param);
    static void RecvThreadFun(void *param);

signals:
    void recvPack(QString pack);

private:
    SOCKET keep_sock_;
    SOCKET action_sock_;
    BOOL is_connected_;
    HANDLE send_event_;

    std::string send_str_;

    std::thread kelv_thread_;
    std::thread send_thread_;
    std::thread recv_thread_;
    std::mutex send_mutex_;
    std::mutex recv_mutex_;
};

#endif // COMM_H
