#ifndef COMM_H
#define COMM_H

#include <winsock2.h>
#include <QThread>
#include <string>

class Comm : public QThread
{
    Q_OBJECT
public:
    explicit Comm(QObject * parent = 0);
    ~Comm();

    bool linkInfo(QString ip, QString port);
    bool sendData(std::string data);
    void run();

    void setQuitFlag(bool flag) { m_quit_flag = flag; }

signals:
    void recvPack(std::string data);

private:
    bool m_quit_flag;
    SOCKET m_client;
    sockaddr_in m_home_addr;
    QString m_ip;
    QString m_port;
    char m_send_data[MAX_PATH];
    char * m_kepplive_pwd;
};

#endif // COMM_H
