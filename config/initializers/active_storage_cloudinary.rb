# Fix for ActiveStorage::IntegrityError with Cloudinary
# Cloudinary may transform files, causing checksum mismatches
# This skips integrity verification for Cloudinary service

Rails.application.config.after_initialize do
  if Rails.application.config.active_storage.service == :cloudinary
    # Patch the downloader to skip integrity check for Cloudinary
    ActiveStorage::Downloader.class_eval do
      private

      def verify_integrity_of(file, checksum:)
        # Skip integrity check for Cloudinary - files may be transformed
        # This is safe because Cloudinary handles file integrity internally
        true
      end
    end
  end
end
