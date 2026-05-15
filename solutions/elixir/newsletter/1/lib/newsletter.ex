defmodule Newsletter do
  def read_emails(path) do
    with {:ok, content} <- File.read(path) do
      content |> String.split("\n") |> Enum.reject(fn email -> email == "" end)
    end
  end

  def open_log(path) do
    with {:ok, io_device} <- File.open(path, [:write]) do
      io_device
    end
  end

  def log_sent_email(pid, email) do
    :ok = IO.write(pid, email <> "\n")
  end

  def close_log(pid) do
    :ok = File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    log = open_log(log_path)
    emails = read_emails(emails_path)

    Enum.each(emails, fn email ->
      if send_fun.(email) == :ok, do: log_sent_email(log, email)
    end)

    close_log(log)
  end
end
