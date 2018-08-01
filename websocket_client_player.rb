require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'byebug'

access_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJ1aWQiOiIwNTA4YTExNi0xMjM5LTRlMjgtYjE1MC04NWE4ZTNlNmI0MDAiLCJzaWQiOiIxOTE0MzM3ZS1kYTEwLTRiMzAtODM5MC1hNmNjNTIwMWQ3MjYiLCJpYXQiOjE1MzMxMDc4MjEsImV4cCI6MTUzMzE5NDIyMSwianRpIjoiNDY1YjUxZjAtMmExOC00YTFmLWI4ODctMWQ2YzMyMDE5NjUyIiwic2lnIjoiZjgzN2ViZWI0YzI5ODFhZDljNjRiNzBkMGIwZDE4NzI0Yzc2YzYwNzgxYjllNGJmN2E1ODI1MTBkZjdhZGEzOSJ9.QOCum6h7Vkp6nrUsp7zLjshETwdJYwYL5wS3lU9x6HlonWRy2t3UT1MPQ_ekG-K7aaQ-D1OKjqcMpHY4yjj8rFXxfIQ6Lus1rdYY2C1WLo8vn209FkfHbrEXptDQIhiIxN1WaYXFjWvrDxISRdd4Fi3X7gWUXZ-nKLcObTgdvRo"

authorization = format('Bearer %s', access_token)

EM.run {
  ws = Faye::WebSocket::Client.new('wss://blaze.mixin.one/', ["Mixin-Blaze-1"],
    :headers => { 'Authorization' => authorization }
  )

  ws.on :open do |event|
    p [:open]

    ws.send({
      "id": SecureRandom.uuid,
      "action": "LIST_PENDING_MESSAGES"
    }.to_json)
  end

  ws.on :message do |event|
    p [:message]
    msg = event.data
    byebug
  end

  ws.on :error do |event|
    p [:error]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
    EM.stop
  end
}
