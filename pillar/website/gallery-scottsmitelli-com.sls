#!yaml|gpg

website:
  gallery-scottsmitelli-com:
    enable_ssl: True

    # Fresh Installation:
    #     `login_txt` must be any non-False value BEFORE starting the installer
    #     to avoid a white "Error" page. During the "Authenticate Me" step,
    #     copy the hex string into `login_txt` and re-apply the Salt states.
    # Normal Operation:
    #     `login_txt` must be False. `setup_password` is not *necessarily* the
    #     same as the admin password in the database.
    login_txt: False
    setup_password: |
      -----BEGIN PGP MESSAGE-----

      hQIMA/EHVCikJY6NAQ//Z3nCYi1nAMwS7KrVCAXovzI/NB1mhgxLlc7JVSmYbni6
      CxEHI+CIHeSKCU8NerJ1wYadGCh7z910/X0aphjQLZE5I+EDhnJJ3uCb9dEMV/sB
      YsvHJiPbMAvrCGo6OImGAjm2snkJrFo+5oRxWdGmSTw8F4xQFKOwciJjcbuH7Tpu
      wOeq7ijO0B5momKX0ITKoyaE/jIt57xtNskce3vHrFogwiz1Bfxfg/EjPsucENWu
      uBi5z4PGeOvNF+B1qQiDKkSZeP38lJXpx0u92FTYqVnhFVEpOtV8JdU8Az7rAwcq
      Q7/NQXKUqN9RYFtMrg13WeNjw3ShqFRB9I9nWRpcdpWBldchvtZFYfSoxoX9R5rw
      ku8Gaba+dKTdcbrg5fCqIrUkpH+8C1pdbZX/iwkwwJ+jxLe3xFPrS9zJGNhuU/5Z
      5h1iXbhz27ON84DFvS78wbn7z3fSaj5McquqNcfn3is1cn53xeGRqxXJQ00QxhUd
      aRSr4Md1uFvmniYusPXpfceOyK23EXj1I7iLBXwUhIKjFw2uEZJlJUfSiLcQiEf4
      Jm8WU/lZDQnoLeYjT1JCfUC/L+LiUlrP4F04ldOgGcSo6lp8E1hUrO+OsRgRRk0Q
      yXdJdXNrc5Jjh1xnGHBqa0RfODeO4dhjRmFOJo+E/DQMTWu13YRw+P5hrEfzkD3S
      TwEBn0aDyTHIlSNWNgdBsVPrd1XiwZfgk8wGNllUVm7n7mq6BAVMA9pofYjPgZFv
      pl28ekTuWXfCPprLbImA5VpcwKJRb8PbN6cPFVAfQvg=
      =CQaV
      -----END PGP MESSAGE-----
