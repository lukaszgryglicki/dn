require 'pry'

$depth = 0

def kni(n, depth)
  $depth = depth
  res = 1 + rand(n)
  return 3 - kni(n, depth + 1) if res == 1
  return (n - 2) + kni(n, depth + 1) if res == n
  return res
end

def kn(n)
  $depth = 0
  if n > 2
    retval = kni(n, 1)
  else
    retval = 0
  end
  depth = $depth
  $depth = 0
  return [depth, retval]
end

if ARGV.count < 3
  puts "Required arguments: N_trials N_casts D_size"
  exit 1
end

t = ARGV[0].to_i
n = ARGV[1].to_i
d = ARGV[2].to_i
s = 0
res = []
t.times do
  reslt = 0
  dpth = 0
  n.times do
    out = kn(d)
    dpth += out[0]
    reslt += out[1]
  end
  res << [dpth, reslt]
end

occ1 = {}
occ2 = {}
res.each do |data|
  depth, value = *data
  occ1[value] = 0 unless occ1.key?(value)
  occ1[value] += 1
  occ2[value] = {} unless occ2.key?(value)
  occ2[value][depth] = 0 unless occ2[value].key?(depth)
  occ2[value][depth] += 1
end

arr1 = []
arr2 = []
occ1.each do |value, k|
  arr1 << [value, k, 100.0 * (k.to_f / t.to_f)]
end
arr1_by_count = arr1.sort_by { |r| -r[1] }
arr1_by_value = arr1.sort_by { |r| r[0] }

occ2.each do |value, data|
  data.each do |depth, k|
    arr2 << [value, depth, k, 100.0 * (k.to_f / t.to_f)]
  end
end
arr2_by_count = arr2.sort_by { |r| -r[2] }
arr2_by_value = arr2.sort_by { |r| [r[0], r[1]] }

puts "#{n} * k(#{d}) tried #{t} times:"
=begin
p res
p occ1
p occ2
p arr1
p arr2

arr1_by_value.each do |row|
  value, k, perc = *row
  puts "value=#{'%6d' % value}\tcount:#{'%6d' % k}\t#{perc}"
end

arr2_by_value.each do |row|
  value, depth, k, perc = *row
  puts "value:#{'%6d' % value}\tdepth:#{'%6d' % depth}\tcount:#{'%6d' % k}\t#{perc}"
end
=end

aggr = {}
arr2_by_value.each do |row|
  value = row[0]
  aggr[value] = [] unless aggr.key?(value)
  aggr[value] << row 
end

aggr.keys.sort.each do |value|
  data = aggr[value]
  sum_perc = 0.0
  sum_count = 0
  percs = {}
  data.each do |row|
    v, depth, k, perc = *row
    sum_perc += perc
    sum_count += k
    percs[depth] = [0.0, 0] unless percs.key?(depth)
    percs[depth][0] += perc
    percs[depth][1] += k
  end
  #p [value, sum_perc, percs]
  s = "#{'%6d' % value}\t#{'%6d' % sum_count}\t#{'%8.3f' % sum_perc.round(5)}%\t["
  percs.keys.sort.each do |k|
    p, pk = *percs[k]
    pp = 100.0 * (p / sum_perc)
    s+= "#{k}: #{pk} (#{p.round(5)}%: #{pp.round(5)}%), "
  end
  s = s[0..-3] + ']'
  puts s
end


