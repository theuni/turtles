package=native_binutils
$(package)_version=2.29.1
$(package)_download_path=http://ftpmirror.gnu.org/binutils
$(package)_file_name=binutils-$($(package)_version).tar.xz
$(package)_sha256_hash=e7010a46969f9d3e53b650a518663f98a5dde3c3ae21b7d71e5e6803bc36b577

define $(package)_set_vars
  $(package)_config_opts=--disable-nls
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--enable-plugins
  $(package)_config_opts+=--disable-install-libbfd
  $(package)_config_opts+=--disable-host-shared
  $(package)_config_opts+=--enable-deterministic-archives
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--program-prefix=$(build)-
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--with-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=CC=$(old_build_toolchain_CC)
  $(package)_config_opts+=CXX=$(old_build_toolchain_CXX)
  $(package)_config_opts+=AR=$(old_build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(old_build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(old_build_toolchain_STRIP)
  $(package)_config_opts+=NM=$(old_build_toolchain_NM)
  $(package)_config_opts+=CFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CXXFLAGS=$($(package)_cflags)
endef

define $(package)_config_cmds
  ./configure $$($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip
endef
