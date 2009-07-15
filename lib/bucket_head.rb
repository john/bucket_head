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

# TO DO:
# - deal with mime type

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
  # valid args: uri, key, access, content_type
  def self.put(args={})
    raise "Required arguments are :uri and :key." unless (args.has_key?(:uri) && args.has_key?(:key))
    response      = Net::HTTP.get_response( URI.parse(args[:uri]) )
    access        = (args.has_key?(:access)) ? args[:access] : 'public-read'
    @content_type = (args.has_key?(:content_type)) ? args[:content_type] : response.content_type
    
    # these both use response.body, make sure it's an IO object.
    # can this get the content_type from the response?
    case response.code
      when "200"
        if self.library == 'right_aws'
          BucketHead.bucket.put( args[:key], response.body, {}, access)
        else
          AWS::S3::S3Object.store( args[:key],
                                   response.body,
                                   BucketHead.bucket.name,
                                   { :content_type => @content_type, :access => access } )
        end
      else
        raise "Could not retreive file to bucketize."
    end
  end

end