class GraderService
  include HTTParty
  debug_output $stdout
  base_uri ENV["GRADER"]

  # https://grader.crowdai.org:10000/
  # GraderService.new(submission_id: 358).call

  def initialize(submission_id:)
    @submission = Submission.find(submission_id)
  end

  def call
    @body = api_query
    if @body

      puts self.class.base_uri
      puts @submission.inspect
      puts
      puts @body.inspect
      puts
      response = call_grader

      puts response.inspect
      
      evaluate_response(
        submission_id: @submission.id,
        response: response)
    else
      Submission.update(
        @submission.id,
        grading_status: 'failed',
        grading_message: 'Files were not received by server.')
      raise "Grader called for submission #{@submission.id} but key cannot be found"
    end
  end

  def call_grader
    begin
      response = self.class.post('/enqueue_grading_job',body: @body)
      return response
    rescue => e
      Submission.update(
        @submission.id,
        grading_status: 'failed',
        grading_message: 'Grading process system error.')
      raise e
    end
  end

  def evaluate_response(submission_id:,response:)
    if response
      r = response.parsed_response
      Submission.update(
        submission_id,
        grading_status: r["grading_status"],
        grading_message: r["grading_message"])
    else
      Submission.update(
        submission_id, grading_status: 'failed',
        grading_message: 'Grading process system error.')
    end
  end

  private
  def api_query
    challenge = @submission.challenge
    participant = @submission.participant
    submission_key = get_submission_key

    body = {
      response_channel: "na",
      session_token: "na",
      api_key: participant.api_key,
      grader_id: 'CLEFChallenges', #challenge.grader_identifier,
      challenge_client_name: challenge.challenge_client_name,
      function_name: "submit",
      data: [{"file_key": get_submission_key, submission_id: @submission.id}],
      dry_run: 'false',
      parallel: 'false',
      enqueue_only: 'false',
      grader_api_key: ENV['CROWDAI_API_KEY']
    }
  end

=begin
var _args = {}
  _args["response_channel"] = "na"
  _args["session_token"] = "na"
  _args["api_key"] = participant_api_key
  _args["grader_id"] = grader_id
  _args["challenge_client_name"] = challenge_client_name
  _args["function_name"] = "submit"
  _args["data"] = [{"file_key":s3_key}]
  _args["dry_run"] = false
  _args["parallel"] = false
  _args["enqueue_only"] = false
  _args["GRADER_API_KEY"] = grader_api_key
=end

  def get_submission_key
    key = @submission.submission_files.first.submission_file_s3_key
  end

end