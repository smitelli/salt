#!pyobjects

NTP_PKG = NTP_SERVICE = 'ntp'

with Pkg.latest(NTP_PKG):
    with Pkg(NTP_PKG, 'watch'):
        Service.running(NTP_SERVICE, enable=True)
