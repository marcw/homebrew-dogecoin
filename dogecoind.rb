require 'formula'

class Dogecoind < Formula
    head 'https://github.com/dogecoin/dogecoin.git', :using => :git

    url 'https://github.com/dogecoin/dogecoin/archive/1.5.1.tar.gz'
    sha1 '70efea48f293c6d10281cf2251720fd8f184196d'

    depends_on 'miniupnpc'
    depends_on 'openssl'
    depends_on 'berkeley-db'
    depends_on 'boost' => 'universal'

    def install
        inreplace 'contrib/debian/examples/dogecoin.conf', '#testnet=1', 'testnet=1'
        inreplace 'contrib/debian/examples/dogecoin.conf', '#server=1', 'server=1'
        inreplace 'contrib/debian/examples/dogecoin.conf', '#rpcuser=Ulysseys', 'rpcuser=dogecoin'
        inreplace 'contrib/debian/examples/dogecoin.conf', '#rpcpassword=YourSuperGreatPasswordNumber_385593', 'rpcpassword=changeme'
        inreplace 'src/makefile.osx', 'CFLAGS += -stdlib=libstdc++', '#CFLAGS += -stdlib=libstdc++'

        cd 'src' do
            system 'make -f makefile.osx'
        end

        bin.install 'src/dogecoind'
        etc.install 'contrib/debian/examples/dogecoin.conf'
        bash_completion.install 'contrib/dogecoind.bash-completion'
        man1.install 'contrib/debian/manpages/dogecoind.1'
        man5.install 'contrib/debian/manpages/dogecoin.conf.5'
    end

    test do
        system "#{bin}/dogecoind", '-?'
    end

    def plist; <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <false/>
            <key>ProgramArguments</key>
            <array>
                <string>#{bin}/bin/dogecoind</string>
                <string>-conf</string>
                <string>#{etc}/dogecoind.conf</string>
                <string>-pid</string>
                <string>#{var}/run/dogecoind.pid</string>
            </array>
            <key>WorkingDirectory</key>
            <string>#{HOMEBREW_PREFIX}</string>
        </dict>
        </plist>
        EOS
    end
end
