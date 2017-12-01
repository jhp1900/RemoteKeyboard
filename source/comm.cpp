#include <cstring>
#include <QDebug>

#include "comm.h"

Comm::Comm(QObject * parent)
    : QThread(parent)
    , m_quit_flag(false)
    , m_client(INVALID_SOCKET)
    , m_ip("")
    , m_port("")
    //, m_send_data(NULL)
    , m_kepplive_pwd("KEPPLIVE")
{
    WORD sockVersion = MAKEWORD(2, 2);
    WSADATA data;
    WSAStartup(sockVersion, &data);

    //m_kepplive_pwd = ;
}

Comm::~Comm()
{
}

bool Comm::linkInfo(QString ip, QString port)
{
    m_ip = ip;
    m_port = port;

    m_home_addr.sin_family = AF_INET;
    m_home_addr.sin_port = htons(m_port.toUShort());
    m_home_addr.sin_addr.S_un.S_addr = inet_addr(m_ip.toLatin1().data());
}

bool Comm::sendData(std::string data)
{
    return true;
}

void Comm::run()
{
    m_quit_flag = false;

    while (true) {
        if(m_quit_flag)
            break;

        Sleep(1000);

        m_client = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if(m_client == INVALID_SOCKET) {
            qDebug() << "INVALID_SOCKET !";
            continue;
        }

        if(::connect(m_client, (sockaddr*)&m_home_addr, sizeof(m_home_addr)) == SOCKET_ERROR) {
            qDebug() << "connect error !";
            closesocket(m_client);
            continue;
        }

        send(m_client, m_kepplive_pwd, strlen(m_kepplive_pwd), 0);

        char *data;
        int ret = ::recv(m_client, data, 1024 * 2, 0);
        if(ret > 0){
            data[ret] = 0x00;
            emit recvPack(data);
        }
        closesocket(m_client);
    }
}
