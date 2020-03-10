defmodule VotingWeb.Admin.UploadControllerTest do
  use VotingWeb.ConnCase, async: true
  use Mimic

  import VotingWeb.AdminAuth

  describe "create/2" do
    setup %{conn: conn} do
      conn = authenticate(conn)
      %{conn: conn}
    end

    test "returns 200 when upload is success", %{conn: conn} do
      expect(ExAws, :request, fn _ -> {:ok, %{status_code: 200}} end)

      params = %{
        "file" => %Plug.Upload{
          content_type: "image/jpeg",
          filename: "p07sf8xm.jpg",
          path: "/tmp/plug-1583/multipart-1583800119-548488569423182-2"
        }
      }

      conn = post(conn, "/api/v1/uploads", params)
      assert %{"status" => "ok", "data" => %{"url" => _}} = json_response(conn, 200)
    end

    test "returns 400 when file is too large", %{conn: conn} do
      reject(&ExAws.request/1)

      params = %{
        "file" => %Plug.Upload{
          content_type: "image/jpeg",
          filename: "p07sf8xm.jpg",
          path: "/users/local/images/large_logo.jpg"
        }
      }

      conn = post(conn, "/api/v1/uploads", params)
      assert %{"status" => "file_too_large"} = json_response(conn, 400)
    end

    test "returns 400 when upload is failed", %{conn: conn} do
      expect(ExAws, :request, fn _ -> {:error, %{status_code: 500}} end)

      params = %{
        "file" => %Plug.Upload{
          content_type: "image/jpeg",
          filename: "p07sf8xm.jpg",
          path: "/tmp/plug-1583/multipart-1583800119-548488569423182-2"
        }
      }

      conn = post(conn, "/api/v1/uploads", params)
      assert %{"status" => "upload_error"} = json_response(conn, 400)
    end
  end
end
