package=native_binutils_stage2
$(package)_version=$(native_binutils_version)
$(package)_download_path=$(native_binutils_download_path)
$(package)_file_name=$(native_binutils_file_name)
$(package)_sha256_hash=$(native_binutils_sha256_hash)
$(package)_dependencies=native_binutils native_gcc_stage3
$(package)_linux_dependencies=native_musl native_linux_system_headers

define $(package)_set_vars
  $(package)_config_opts=--disable-nls
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--program-prefix=$(build)-
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--with-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--with-build-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--enable-deterministic-archives
  $(package)_config_opts+=--enable-gold
  $(package)_config_opts+=--disable-install-libbfd
  $(package)_config_opts+=--disable-host-shared
  $(package)_config_opts+=--with-pic
  $(package)_config_opts+=--enable-plugins
  $(package)_config_opts+=--enable-threads
  $(package)_config_opts+=CC=$(build_toolchain_CC)
  $(package)_config_opts+=CXX=$(build_toolchain_CXX)
  $(package)_config_opts+=AR=$(build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(build_toolchain_STRIP)
  $(package)_config_opts+=NM=$(build_toolchain_NM)
  $(package)_config_opts+=CFLAGS=$($(package)_cflags)
  $(package)_config_opts+=CXXFLAGS=$($(package)_cxxflags)
endef

define $(package)_config_cmds
  ./configure $$($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip && \
  mkdir -p $($(package)_staging_prefix_dir)/$(build)/sys-root
endef
