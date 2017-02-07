Puppet::Functions.create_function(:'balancer::domains_to_ips') do
  dispatch :convert do
    param 'Array', :domains
    return_type 'Array'
  end

  def convert(domains)
    domains.map do |domain|
      ip = `tracepath -n #{domain} | tail -n 2 | head -n 1 | awk '{print $2}'`
      [domain, ip]
    end
  end
end