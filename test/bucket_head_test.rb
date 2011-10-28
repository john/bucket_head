require 'test_helper'

class BucketHeadTest < Test::Unit::TestCase

  context "set_bucket" do
    setup do
      BucketHead.set_bucket_name( 'buck_buck_bucket' )
    end

    should "set the bucket name" do
      assert_equal 'buck_buck_bucket', BucketHead.bucket_name
    end
  end

  context "bucket access" do
    should "be public-read by default" do
      BucketHead.set_bucket_access(nil)
      assert_equal 'public-read', BucketHead.bucket_access
    end

    should "be overrideable to private" do
      BucketHead.set_bucket_access( 'private' )
      assert_equal 'private', BucketHead.bucket_access
    end
  end

  context "library" do
    should "be either right_aws or aws/s3" do
      assert_match /right_aws|aws\/s3/, BucketHead.library
    end
  end

  context "bucket" do
    should_eventually "return either a right_aws or aws/s3 bucket object" do
      # why does this need to be in the BucketHead namespace?
      BucketHead::AWS_CREDENTIALS = { :access_key => 'your-key-goes-here',
                          :secret_access_key => 'your-top-secret-key-goes-here'}
      BucketHead.set_bucket_name( 'buck_buck_bucket' )

      # mocha?
      assert_equal 'foo', BucketHead.bucket.class.to_s
    end
  end

  context "put" do
    should_eventually "move something over to S3" do
      # mock
    end
  end

end
