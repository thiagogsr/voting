defmodule Voting.Uploader do
  @moduledoc """
  Upload files to AWS S3
  """

  @file_size_limit 5_000_000

  alias ExAws.{S3, S3.Upload}

  def run(%{filename: filename, content_type: content_type, path: path}) do
    bucket = Application.get_env(:voting, :uploads_bucket)

    with :ok <- check_file_size(path),
         {:ok, filename} <- generate_filename(filename) do
      case stream_to_s3(filename, content_type, path, bucket) do
        {:ok, %{status_code: 200}} ->
          {:ok, "https://#{bucket}.s3.amazonaws.com/#{filename}"}

        _ ->
          {:error, :upload_error}
      end
    end
  end

  defp check_file_size(path) do
    file_module = Application.get_env(:voting, :file_module)
    {:ok, %{size: size}} = file_module.stat(path)

    if size <= @file_size_limit do
      :ok
    else
      {:error, :file_too_large}
    end
  end

  defp stream_to_s3(filename, content_type, contents, bucket) do
    contents
    |> Upload.stream_file()
    |> S3.upload(bucket, filename, content_type: content_type)
    |> ExAws.request()
  end

  defp generate_filename(filename) do
    filename =
      filename
      |> file_extension()
      |> unique_filename()

    {:ok, filename}
  end

  defp unique_filename(extension) do
    UUID.uuid4() <> "." <> extension
  end

  defp file_extension(filename) do
    filename
    |> String.split(".")
    |> List.last()
  end
end
