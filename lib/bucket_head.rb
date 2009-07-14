# Usage:

# BucketHead.set_bucket_name('int-xml')
# BucketHead.put('http://puffy.ec2.nytimes.com/api/phu/count.xml', 'phu_count.xml')

# results in the contents of the specified URI being uploaded to:
# http://int-xml.s3.amazonaws.com/phu_count.xml

# by default buckets and anything put in them have 'public-read' access
# you can set bucket permissions, if, prior to bucket creation, you call:
# BucketHead.set_bucket_access( 'public-read|private|whatever')

# you can set access on individual objects within buckets by passing permissions as an optional 3rd argument:
# BucketHead.put('http://puffy.ec2.nytimes/api/phu/count.xml', 'phu_count.xml', 'private')

# the default mime type is text/xml. if you want to set a different mime type, pass it in as an
# optional third argument to the BucketHead.put:

require 'rubygems'
require 'net/ssh'
require 'net/http'
require 'uri'

begin
  require 'right_aws'
  @@library='right_aws'
rescue
  require 'aws/s3'
  @@library='aws/s3'
end

# BucketHead.set_bucket_name 'int-tester'
# BucketHead.set_bucket_access 'public-read'
# BucketHead.put('http://wordie.org', 'test.html')

# TO DO:
# - deal with mime type issues aron mentioned

class BucketHead
  
  def self.bucket_name
    raise "undefined bucket name!" if @bucket.nil?
    @bucket
  end
  
  def self.set_bucket_name(name)
    @bucket = name.to_s
  end
  
  def self.bucket_access
    @bucket_access = 'public-read' if @bucket_access.empty?
    @bucket_access
  end
  
  # method to set bucket access
  def self.set_bucket_access(bucket_access='public-read')
    @bucket_access = bucket_access.to_s
  end
  
  def self.library
    @@library = 'aws/s3' if @@library.nil?
    @@library
  end
  
  def self.bucket
    if @@library == 'right_aws'
      s3 = RightAws::S3.new( AWS_CREDENTIALS[:access_key], AWS_CREDENTIALS[:secret_access_key] )
      s3.bucket(bucket_name, true, self.bucket_access)
    else
      AWS::S3::Base.establish_connection!( :access_key_id => AWS_CREDENTIALS[:access_key],
                                           :secret_access_key => AWS_CREDENTIALS[:secret_access_key] )
      AWS::S3::Bucket.find(bucket_name)
    end
  end
  
  # have this accept arrays and strings. if it's an array, loop and bucketize everything in it, with array index as key
  # def self.put(uri, key, access='public-read', content_type='text/xml')
  def self.put(args={})
    raise "Required arguments are :uri and :key." unless (args.has_key?(:uri) && args.has_key?(:key))
    access       = (args.has_key?(:access)) ? args[:access] : 'public-read'
    content_type = (args.has_key?(:content_type)) ? args[:content_type] : 'text/xml'
    response     = Net::HTTP.get_response( URI.parse(args[:uri]) )
    case response.code
      when "200"
        if self.library == 'right_aws'
          BucketHead.bucket.put( args[:key], response.body, {}, access)
        else
          AWS::S3::S3Object.store( args[:key],
                                   response.body,
                                   BucketHead.bucket.name,
                                   { :content_type => content_type, :access => access } )
        end
      else
        raise "Could not retreive file to bucketize."
    end
  end

end