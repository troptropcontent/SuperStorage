# typed: true
# frozen_string_literal: true

module SuperStorage
  # This class represents an uploaded file.
  class UploadedFile < T::Struct
    const :file_name, String
    const :file, T.any(String, File)
  end
end
