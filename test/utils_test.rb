require "test_helper"

class UtilsTest < Minitest::Test
  include TestHelpers::Interactions

  def setup
    @utils = Uploadie::Utils
  end

  test "copy_to_tempfile returns a tempfile" do
    tempfile = @utils.copy_to_tempfile("foo", fakeio)

    assert_instance_of Tempfile, tempfile
  end

  test "copy_to_tempfile rewinds the tempfile" do
    tempfile = @utils.copy_to_tempfile("foo", fakeio)

    assert_equal 0, tempfile.pos
  end

  test "copy_to_tempfile uses the basename" do
    tempfile = @utils.copy_to_tempfile("foo", fakeio)

    assert_match "foo", tempfile.path
  end

  test "copy_to_tempfile opens the tempfile in binmode" do
    tempfile = @utils.copy_to_tempfile("foo", fakeio)

    assert tempfile.binmode?
  end

  test "download downloads the file to disk" do
    tempfile = @utils.download(image_url)

    assert File.exist?(tempfile.path)
  end

  test "download exposes the original filename" do
    tempfile = @utils.download(image_url)

    assert_equal "mark-github-128.png", tempfile.original_filename
  end

  test "download exposes the content type" do
    tempfile = @utils.download(image_url)

    assert_equal "image/png", tempfile.content_type
  end

  test "download unifies different kinds of upload errors" do
    assert_raises(Uploadie::Error) { @utils.download(invalid_url) }
  end
end
