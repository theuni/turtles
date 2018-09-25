
package=native_gcc_stage2
$(package)_version=$(native_gcc_version)
$(package)_download_path=$(native_gcc_download_path)
$(package)_file_name=$(native_gcc_file_name)
$(package)_sha256_hash=$(native_gcc_sha256_hash)
$(package)_build_subdir=build
$(package)_dependencies=native_binutils
$(package)_linux_dependencies=native_musl native_linux_system_headers
$(package)_mingw32_dependencies=native_mingw-w64-headers native_mingw-w64-crt
$(package)_patches=0001-default-static-pie.patch 0002-autoconf.patch 0003-fixup-static-pie.patch
$(package)_patches+=0001-Introduce-gcc_qsort.patch 0002-gcc_qsort-avoid-oversized-memcpy-temporaries.patch 0003-gcc_qsort-avoid-overlapping-memcpy-PR-86311.patch 0004-qsort_chk-call-from-gcc_qsort-instead-of-wrapping-it.patch


$(package)_mpfr_version=$(native_gcc_mpfr_version)
$(package)_mpfr_download_path=$(native_gcc_mpfr_download_path)
$(package)_mpfr_file_name=$(native_gcc_mpfr_file_name)
$(package)_mpfr_sha256_hash=$(native_gcc_mpfr_sha256_hash)

$(package)_gmp_version=$(native_gcc_gmp_version)
$(package)_gmp_download_path=$(native_gcc_gmp_download_path)
$(package)_gmp_file_name=$(native_gcc_gmp_file_name)
$(package)_gmp_sha256_hash=$(native_gcc_gmp_sha256_hash)

$(package)_mpc_version=$(native_gcc_mpc_version)
$(package)_mpc_download_path=$(native_gcc_mpc_download_path)
$(package)_mpc_file_name=$(native_gcc_mpc_file_name)
$(package)_mpc_sha256_hash=$(native_gcc_mpc_sha256_hash)

$(package)_extra_sources=$($(package)_mpfr_file_name) $($(package)_gmp_file_name) $($(package)_mpc_file_name)

define $(package)_fetch_cmds
$(call fetch_file,$(package),$($(package)_download_path),$($(package)_file_name),$($(package)_file_name),$($(package)_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpfr_download_path),$($(package)_mpfr_file_name),$($(package)_mpfr_file_name),$($(package)_mpfr_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_gmp_download_path),$($(package)_gmp_file_name),$($(package)_gmp_file_name),$($(package)_gmp_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_mpc_download_path),$($(package)_mpc_file_name),$($(package)_mpc_file_name),$($(package)_mpc_sha256_hash))
endef

define $(package)_extract_cmds
  echo "source: $($(package)_staging_dir)" && \
  mkdir -p $($(package)_extract_dir) && \
  echo "$($(package)_sha256_hash)  $($(package)_source)" > $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_mpfr_sha256_hash)  $($(package)_source_dir)/$($(package)_mpfr_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_gmp_sha256_hash)  $($(package)_source_dir)/$($(package)_gmp_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_mpc_sha256_hash)  $($(package)_source_dir)/$($(package)_mpc_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  $(build_SHA256SUM) -c $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  tar --strip-components=1 -xf $($(package)_source) && \
  mkdir -p mpfr && tar --strip-components=1 -C mpfr -xf $($(package)_source_dir)/$($(package)_mpfr_file_name) && \
  mkdir -p gmp && tar --strip-components=1 -C gmp -xf $($(package)_source_dir)/$($(package)_gmp_file_name) && \
  mkdir -p mpc && tar --strip-components=1 -C mpc -xf $($(package)_source_dir)/$($(package)_mpc_file_name)
endef
#  patch -p1 < $($(package)_patch_dir)/0002-ssp_nonshared.diff && \
#  patch -p1 < $($(package)_patch_dir)/0010-static-pie-support.diff
#  patch -p1 < $($(package)_patch_dir)/0004-stabilize-vrp.patch && \
#  patch -p1 < $($(package)_patch_dir)/0012-stabilize-tree-ssa-loop-ivopts.patch
#  patch -p1 < $($(package)_patch_dir)/0001-stabilize-dwarf2out.patch

define $(package)_preprocess_cmds
  sed -i 's/-nostdinc++/-nostdinc++ \$$$$(XGCC_FLAGS_FOR_TARGET)/' Makefile.in && \
  patch -p1 < $($(package)_patch_dir)/0001-default-static-pie.patch && \
  patch -p1 < $($(package)_patch_dir)/0002-autoconf.patch && \
  patch -p1 < $($(package)_patch_dir)/0003-fixup-static-pie.patch && \
  patch -p1 < $($(package)_patch_dir)/0001-Introduce-gcc_qsort.patch && \
  patch -p1 < $($(package)_patch_dir)/0002-gcc_qsort-avoid-oversized-memcpy-temporaries.patch && \
  patch -p1 < $($(package)_patch_dir)/0003-gcc_qsort-avoid-overlapping-memcpy-PR-86311.patch && \
  patch -p1 < $($(package)_patch_dir)/0004-qsort_chk-call-from-gcc_qsort-instead-of-wrapping-it.patch
endef

#  patch -p1 < $($(package)_patch_dir)/0009-stabilize-ira-color.patch && \
#  patch -p1 < $($(package)_patch_dir)/0011-tree-ssa-loop-im-small-fix.patch
#
#  --v testing without v--
#  patch -p1 < $($(package)_patch_dir)/0017-more-tree-ssa-loop-im.patch && \
#  --v good without v
#  patch -p1 < $($(package)_patch_dir)/0001-stabilize-genautomata.patch
#  patch -p1 < $($(package)_patch_dir)/0002-stabilize-genopinit.patch
#  patch -p1 < $($(package)_patch_dir)/0003-stabilize-genrecog.patch
#  patch -p1 < $($(package)_patch_dir)/0005-stabilize-i386.patch
#  patch -p1 < $($(package)_patch_dir)/0006-stabilize-dwarf2.patch
#  patch -p1 < $($(package)_patch_dir)/0007-stabilize-ira.patch
#  patch -p1 < $($(package)_patch_dir)/0008-stabilize-class.patch
#  patch -p1 < $($(package)_patch_dir)/0010-stabilize-tree-sra.patch
#  patch -p1 < $($(package)_patch_dir)/0013-stabilize-structalias.patch
#  patch -p1 < $($(package)_patch_dir)/0014-stablize-gimple-ssa-store-merging.patch && \
#  patch -p1 < $($(package)_patch_dir)/0015-stablize-domwalk.patch && \
#  patch -p1 < $($(package)_patch_dir)/0016-stabilize-tree-ssa-loop-niter.patch

define $(package)_set_vars
  $(package)_config_opts=--enable-languages=c,c++
  $(package)_config_opts+=--disable-nls
  $(package)_config_opts+=--disable-multilib
  $(package)_config_opts+=--without-included-gettext
  $(package)_config_opts+=--enable-libstdcxx-time=yes
  $(package)_config_opts+=--enable-fully-dynamic-string
  $(package)_config_opts+=--enable-initfini-array
  $(package)_config_opts+=--prefix=$($(package)_prefix)
  $(package)_config_opts+=--with-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--with-build-sysroot=$($(package)_prefix)/$(build)
  $(package)_config_opts+=--with-native-system-header-dir=/include
  $(package)_config_opts+=--build=$(build)
  $(package)_config_opts+=--enable-bootstrap
  $(package)_config_opts+=--disable-libsanitizer
  $(package)_config_opts+=--disable-shared
  $(package)_config_opts+=--disable-lto
  $(package)_config_opts+=--disable-decimal-float
  $(package)_config_opts+=--disable-threads
  $(package)_config_opts+=--disable-libatomic
  $(package)_config_opts+=--disable-libgomp
  $(package)_config_opts+=--disable-libmpx
  $(package)_config_opts+=--disable-libquadmath
  $(package)_config_opts+=--disable-libvtv
  $(package)_config_opts+=--disable-libssp
  $(package)_config_opts+=--disable-libcc1
  $(package)_config_opts+=--disable-libada
  $(package)_config_opts+=--disable-plugin
  $(package)_config_opts+=--enable-default-pie
  $(package)_config_opts+=--enable-default-static-pie
  $(package)_config_opts+=--enable-default-ssp
  $(package)_config_opts+=--enable-checking=yes
  $(package)_config_opts+=--disable-werror
  $(package)_config_opts+=--disable-libstdcxx-filesystem-ts
  $(package)_config_opts+=--with-build-time-tools=$($(package)_prefix)/bin
  $(package)_config_opts+=CC=$(old_build_toolchain_CC)
  $(package)_config_opts+=CXX=$(old_build_toolchain_CXX)
  $(package)_config_opts+=AR=$(old_build_toolchain_AR)
  $(package)_config_opts+=RANLIB=$(old_build_toolchain_RANLIB)
  $(package)_config_opts+=STRIP=$(old_build_toolchain_STRIP)
  $(package)_config_opts+=NM=$(old_build_toolchain_NM)
endef

define $(package)_config_cmds
  export PATH=$($(package)_prefix)/bin:$(PATH) && \
  ../configure $$($(package)_config_opts)
endef

define $(package)_build_cmds
  export PATH=$($(package)_prefix)/bin:$(PATH) && \
  $(MAKE) && $(MAKE) bootstrap4
endef

define $(package)_stage_cmds
  export PATH=$($(package)_prefix)/bin:$(PATH) && \
  $(MAKE) DESTDIR=$($(package)_staging_dir) install-strip
endef
