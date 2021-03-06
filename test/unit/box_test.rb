require 'test_helper'

class BoxTest < MiniTest::Unit::TestCase
  def setup
    box.up unless box.running?
  end

  def test_ruby_version
    assert_version '/opt/ruby/bin/ruby -v', '1.9.3p392'
  end

  def test_rubygems_version
    assert_version '/opt/ruby/bin/gem -v', '1.8.23'
  end

  def test_nodejs_version
    assert_version 'node -v', '0.10.13'
  end

  def test_phantomjs_version
    assert_version 'phantom -v', '1.9'
  end

  def test_postgresql_version
    assert_version 'pg_config --version', '9.2.4'
  end

  def test_postgresql_connection
    assert_version 'psql -c "select version();" postgres postgres; ls', '9.2.4'
  end

  def test_redis_server_connection
    assert_version 'redis-cli ping', 'PONG'
  end

private

  def assert_version(path, version)
    result = box.exec(path)

    assert result.stdout =~ %r{#{version}}
  end

  def box
    Environment.box
  end

end
