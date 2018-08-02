package=native_old_linux_toolchain
$(package)_version=1.0.0
$(package)_download_path=$(default_build_toolchain_url)
$(package)_file_name=native_gcc-6.2.0-a9393f53cd2.tar.gz

$(package)_old_glibc_version=3.1.4
$(package)_old_glibc_download_path=$($(package)_download_path)
$(package)_old_glibc_file_name=old_glibc-$($(package)_old_glibc_version).tar.xz

$(package)_old_kernel_headers_version=6.1.1
$(package)_old_kernel_headers_download_path=$($(package)_download_path)
$(package)_old_kernel_headers_file_name=old_kernel_headers-$($(package)_old_kernel_headers_version).tar.xz

$(package)_old_binutils_version=1.0.3
$(package)_old_binutils_download_path=$($(package)_download_path)
$(package)_old_binutils_file_name=old_binutils-$($(package)_old_binutils_version).tar.gz

$(package)_extra_sources=$($(package)_old_glibc_file_name) $($(package)_old_kernel_headers_file_name) $($(package)_old_binutils_file_name)

define $(package)_fetch_cmds
$(call fetch_file,$(package),$($(package)_download_path),$($(package)_file_name),$($(package)_file_name),$($(package)_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_old_glibc_download_path),$($(package)_old_glibc_file_name),$($(package)_old_glibc_file_name),$($(package)_old_glibc_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_old_kernel_headers_download_path),$($(package)_old_kernel_headers_file_name),$($(package)_old_kernel_headers_file_name),$($(package)_old_kernel_headers_sha256_hash)) && \
$(call fetch_file,$(package),$($(package)_old_binutils_download_path),$($(package)_old_binutils_file_name),$($(package)_old_binutils_file_name),$($(package)_old_binutils_sha256_hash))
endef

define $(package)_extract_cmds
  mkdir -p $($(package)_extract_dir) && \
  echo "$($(package)_sha256_hash)  $($(package)_source)" > $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_old_glibc_sha256_hash)  $($(package)_source_dir)/$($(package)_old_glibc_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_old_kernel_headers_sha256_hash)  $($(package)_source_dir)/$($(package)_old_kernel_headers_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  echo "$($(package)_old_binutils_sha256_hash)  $($(package)_source_dir)/$($(package)_old_binutils_file_name)" >> $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  $(build_SHA256SUM) -c $($(package)_extract_dir)/.$($(package)_file_name).hash && \
  tar --strip-components=1 -xf $($(package)_source) && \
  mkdir -p old_glibc && tar --strip-components=1 -C old_glibc -xf $($(package)_source_dir)/$($(package)_old_glibc_file_name) && \
  mkdir -p old_kernel_headers && tar --strip-components=1 -C old_kernel_headers -xf $($(package)_source_dir)/$($(package)_old_kernel_headers_file_name) && \
  mkdir -p old_binutils && tar --strip-components=1 -C old_binutils -xf $($(package)_source_dir)/$($(package)_old_binutils_file_name)
endef
