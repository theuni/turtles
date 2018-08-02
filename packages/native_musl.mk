package=native_musl
$(package)_version=1.1.18
$(package)_download_path=https://www.musl-libc.org/releases
$(package)_file_name=musl-$($(package)_version).tar.gz
$(package)_sha256_hash=d017ee5d01aec0c522a1330fdff06b1e428cb409e1db819cc4935d5da4a5a118
$(package)_dependencies=native_gcc native_binutils
$(package)_patches=qsort.c msort.c qsort2.c

define $(package)_set_vars
  $(package)_config_opts=--build=$(build)
  $(package)_config_opts+=--prefix=/
  $(package)_config_opts+=--disable-wrapper
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=CC=$(build_toolchain_CC)
  $(package)_config_opts+=CFLAGS="$($(package)_cflags) -fPIC"
  $(package)_config_opts+=CROSS_COMPILE=$(build_toolchain_prefix)/bin/$(build)-
endef

define $(package)_preprocess_cmds
  cp $($(package)_patch_dir)/qsort.c $($(package)_patch_dir)/msort.c $($(package)_patch_dir)/qsort2.c src/stdlib
endef

define $(package)_config_cmds
  ./configure $$($(package)_config_opts)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_prefix_dir)/$(build) install
endef

#define $(package)_postprocess_cmds
#  mv $(host)/lib/libc.so $(host)/lib/libc_shared.so
#endef
