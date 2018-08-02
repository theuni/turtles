package=native_make
$(package)_version=4.2
$(package)_download_path=https://ftp.gnu.org/gnu/make
$(package)_file_name=make-$($(package)_version).tar.bz2
$(package)_sha256_hash=4e5ce3b62fe5d75ff8db92b7f6df91e476d10c3aceebf1639796dc5bfece655f
$(package)_dependencies=native_binutils_stage2 native_gcc_stage3
$(package)_linux_dependencies=native_musl native_linux_system_headers

define $(package)_set_vars
  $(package)_config_opts=--disable-nls
  $(package)_config_opts+=--without-guile
  $(package)_config_opts+=--without-load
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=CFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CXXFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CC=$(build_toolchain_CC)
  $(package)_config_opts+=CXX=$(build_toolchain_CXX)
  $(package)_config_opts+=AR=$(build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(build_toolchain_STRIP)
endef

define $(package)_config_cmds
  ./configure $($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip
endef
