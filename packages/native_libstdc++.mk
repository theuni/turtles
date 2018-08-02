package=native_libstdc++
$(package)_version=$(native_gcc_version)
$(package)_download_path=$(native_gcc_download_path)
$(package)_file_name=$(native_gcc_file_name)
$(package)_sha256_hash=$(native_gcc_sha256_hash)
$(package)_build_subdir=build
$(package)_dependencies=native_binutils native_gcc
$(package)_linux_dependencies=native_musl native_linux_system_headers
$(package)_mingw32_dependencies=native_mingw-w64-headers native_mingw-w64-crt

define $(package)_set_vars
  $(package)_config_opts=
  $(package)_config_opts+=--host=$(build)
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--disable-nls
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--with-pic
  $(package)_config_opts+=--disable-libstdcxx-threads
  $(package)_config_opts+=--disable-libstdcxx-pch
  $(package)_config_opts+=--with-target-subdir=$(build)
  $(package)_config_opts+=CC=$(old_build_toolchain_CC)
  $(package)_config_opts+=CXX=$(old_build_toolchain_CXX)
  $(package)_cflags+=-fPIC
  $(package)_cxxflags+=-fPIC
endef

define $(package)_config_cmds
  ../libstdc++-v3/configure $$($(package)_config_opts) CFLAGS="$($(package)_cflags)" CXXFLAGS="$($(package)_cxxflags)"
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
