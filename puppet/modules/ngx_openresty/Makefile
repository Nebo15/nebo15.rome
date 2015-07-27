.PHONY: all install clean

all:
	cd /vagrant/puppet/modules/ngx_openresty/build/LuaJIT-2.1-20150622 && $(MAKE) TARGET_STRIP=@: CCDEBUG=-g CC=cc PREFIX=/etc/luajit
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-cjson-2.1.0.2 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/etc/lualib LUA_MODULE_DIR=/etc/lualib CJSON_CFLAGS="-g -fpic" CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-redis-parser-0.10 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_LIB_DIR=/etc/lualib CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-rds-parser-0.05 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_LIB_DIR=/etc/lualib CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/nginx-1.7.10 && $(MAKE)

install: all
	cd /vagrant/puppet/modules/ngx_openresty/build/LuaJIT-2.1-20150622 && $(MAKE) install TARGET_STRIP=@: CCDEBUG=-g CC=cc PREFIX=/etc/luajit DESTDIR=$(DESTDIR)
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-cjson-2.1.0.2 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/etc/lualib LUA_MODULE_DIR=/etc/lualib CJSON_CFLAGS="-g -fpic" CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-redis-parser-0.10 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_LIB_DIR=/etc/lualib CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-rds-parser-0.05 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/vagrant/puppet/modules/ngx_openresty/build/luajit-root/etc/luajit/include/luajit-2.1 LUA_LIB_DIR=/etc/lualib CC=cc
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-dns-0.14 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-memcached-0.13 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-redis-0.20 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-mysql-0.15 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-string-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-upload-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-websocket-0.05 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-lock-0.04 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-lrucache-0.04 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-core-0.1.1 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/lua-resty-upstream-healthcheck-0.03 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/etc/lualib INSTALL=/vagrant/puppet/modules/ngx_openresty/build/install
	cd /vagrant/puppet/modules/ngx_openresty/build/resty-cli-0.03 && /vagrant/puppet/modules/ngx_openresty/build/install resty $(DESTDIR)//etc/bin/
	cd /vagrant/puppet/modules/ngx_openresty/build/nginx-1.7.10 && $(MAKE) install DESTDIR=$(DESTDIR)

clean:
	rm -rf build
