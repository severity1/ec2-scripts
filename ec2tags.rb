require 'facter'
require 'json'

if Facter.value("ec2_instance_id") != nil
 instance_id = Facter.value("ec2_instance_id")
 region = Facter.value("ec2_placement_availability_zone")[0..-2]
 tags = Facter::Util::Resolution.exec("aws ec2 describe-tags --region #{region} --filters \"Name=resource-id,Values=#{instance_id}\" --query 'Tags[*].{value:Value,key:Key}'")

 parsed_tags = JSON.parse(tags)
 parsed_tags.each do |tag|
  fact = "ec2_tag_#{tag["key"]}"
  Facter.add(fact) { setcode { tag["value"] } }
 end
end
