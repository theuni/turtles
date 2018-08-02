package=host_glibc
$(package)_version=$(native_glibc_version)
$(package)_download_path=$(native_glibc_download_path)
$(package)_file_name=$(native_glibc_file_name)
$(package)_sha256_hash=$(native_glibc_sha256_hash)
$(package)_build_subdir=build
$(package)_dependencies=host_gcc host_binutils
$(package)_linux_dependencies=host_linux_system_headers

define $(package)_set_vars
  $(package)_config_opts=--prefix=$($(package)_prefix)/$(host)
  $(package)_config_opts+=--host=$(host_arch)-stage1-$(host_os)
  $(package)_config_opts+=--enable-kernel=2.6.32
  $(package)_config_opts+=--with-headers=$($(package)_prefix)/$(host)/include
  $(package)_config_opts+=--disable-multi-arch
  $(package)_config_opts+=--enable-static-nss
  $(package)_config_opts+=--disable-werror
  $(package)_config_opts+=--without-selinux
  $(package)_config_opts+=BUILD_CC=$(build_toolchain_CC)
endef

define $(package)_config_cmds
  export PATH=$($(package)_prefix)/bin:$(PATH) && \
  ../configure $$($(package)_config_opts) CFLAGS=$($(package)_cflags) CXXFLAGS=$($(package)_cxxflags)
endef

define $(package)_build_cmds
  export PATH=$($(package)_prefix)/bin:$(PATH) && \
  $(MAKE)
endef

define $(package)_stage_cmds
  mkdir -p $($(package)_staging_prefix_dir)/lib $($(package)_staging_prefix_dir)/$(host)/lib && \
  ln -rs $($(package)_staging_prefix_dir)/lib $($(package)_staging_prefix_dir)/lib64 && ln -rs $($(package)_staging_prefix_dir)/$(host)/lib $($(package)_staging_prefix_dir)/$(host)/lib64 && \
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef

define $(package)_postprocess_cmds
  sed -i "s|$($(package)_prefix)/$(host)/lib/||g" $(host)/lib/libc.so $(host)/lib/libm.so $(host)/lib/libpthread.so
endef
