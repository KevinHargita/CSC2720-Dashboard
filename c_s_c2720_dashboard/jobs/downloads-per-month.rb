require 'date'
require 'mongo'

module Client_3ci_applicantsPerMonth
Mongo::Logger.logger.level = ::Logger::FATAL

client_host = ['ds259085.mlab.com:59085']
client_options = {
  database: 'csc2720',
  user: 'csc2720',
  password: 'csc2720project',
}

client = Mongo::Client.new(client_host, client_options)

date = []

client[:users].find({"date" => {"$gt" => 1483228800 } })
.projection({'date' => 1, '_id' => 0})
.each { |item|
date = date.push(item['date'])}

months = date.map { |t| (Time.at(t).to_datetime).month()}
year = date.map { |t| (Time.at(t).to_datetime).year()}


# monthCount = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0}
# monthCount1 = months.uniq.map{|t| [t,months.count(t)]}.to_h
# monthCount3 = monthCount.merge(monthCount1)

monthPlaceholder = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0}
monthCount = months.uniq.map{|t| [t,months.count(t)]}.to_h
@monthMerged = monthPlaceholder.merge(monthCount)

labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
len = labels.length

data = [
  {
    label: 'Unique downloads per month',
    data: @monthMerged.values,
    #backgroundColor: ('rgba(255, 99, 132, 0.2)') * labels.length,
    #borderColor: ('rgba(255, 99, 132, 1)') * labels.length,
    backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * len,
    borderColor: [ 'rgba(255, 99, 132, 1)' ] * len,
    pointBackgroundColor: "rgba(255, 99, 132, 1)",
    pointBorderColor: "#fff",
    pointHoverBackgroundColor: "rgba(255, 99, 132, 1)",
    pointHoverBorderColor: "rgba(255, 99, 132, 1)",
    borderWidth: 1
  }]
options = {
scales: {
    xAxes: [{
        stacked: false,
        beginAtZero: true,
        # scaleLabel: {
        #     labelString: 'Recruiter'
        # },
        ticks: {
            stepSize: 1,
            min: 0,
            autoSkip: false
        }
    }]
}
}

# SCHEDULER.every '10m', :first_in => 0 do |job|

send_event('downloads-per-month', { labels: labels, datasets: data, options: options })

# end 
  def self.monthMerged
      return @monthMerged.values
  end

puts len
end


