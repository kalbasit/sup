# encoding: utf-8

require "test_helper"

require "sup/util/query"
require "xapian"

describe Redwood::Util::Query do
  describe ".describe" do
    it "returns a UTF-8 description of query" do
      query = Xapian::Query.new "テスト"
      life = "生活: "

      assert_raises Encoding::CompatibilityError do
        _ = life + query.description
      end

      desc = Redwood::Util::Query.describe(query)
      _ = (life + desc) # No exception thrown
    end

    it "returns a valid UTF-8 description of bad input" do
      msg = "asdfa \xc3\x28 åasdf"
      query = Xapian::Query.new msg
      life = 'hæi'

      # this is now possibly UTF-8 string with possibly invalid chars
      desc = Redwood::Util::Query.describe (query)

      assert_raises Encoding::CompatibilityError do
        _ = life + query.description
      end

      _ = (life + desc)

      # try to do something with string: raises invalid byte sequence
      _.gsub(/" "/, "  ")

    end
  end
end
