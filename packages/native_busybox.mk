package=native_busybox
$(package)_version=1.29.0
$(package)_download_path=http://busybox.net/downloads
$(package)_file_name=busybox-$($(package)_version).tar.bz2
$(package)_sha256_hash=c8115612f0be640644e7c35098766ddaac4a88b773c4c4f0e43564982f660c82
$(package)_dependencies=native_binutils native_gcc_stage2
$(package)_linux_dependencies=native_musl native_linux_system_headers
$(package)_patches=config linkfix.patch


define $(package)_set_vars
endef

define $(package)_preprocess_cmds
  patch -p1 < $($(package)_patch_dir)/linkfix.patch && \
  cp $($(package)_patch_dir)/config .config
endef

define $(package)_config_cmds
  $(MAKE) CROSS_COMPILE=$(build_toolchain_prefix)/bin/$(build)- HOSTCC=$(build_toolchain_CC) HOSTCXX=$(build_toolchain_CXX) oldconfig
endef

define $(package)_build_cmds
  $(MAKE) CROSS_COMPILE=$(build_toolchain_prefix)/bin/$(build)- HOSTCC=$(build_toolchain_CC) HOSTCXX=$(build_toolchain_CXX)
endef

define $(package)_stage_cmds
  $(MAKE) CROSS_COMPILE=$(build_toolchain_prefix)/bin/$(build)- CONFIG_PREFIX=$($(package)_staging_prefix_dir)  HOSTCC=$(build_toolchain_CC) HOSTCXX=$(build_toolchain_CXX) install
endef

define $(package)_postprocess_cmds
  rm -rf ./usr/
endef
