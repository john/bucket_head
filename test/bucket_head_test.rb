require 'test_helper'

class BucketHeadTest < Test::Unit::TestCase

  context "set_bucket" do
    setup do
      BucketHead.set_bucket_name( 'buckety_buck_buck' )
    end
    
    should "set the bucket name" do
      assert_equal 'buckety_buck_buck', BucketHead.bucket_name
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
    
    should "return either a right_aws or aws/s3 bucket object" do
      assert_match /foo/, BucketHead.bucket.class.to_s
    end
  end
  
end
