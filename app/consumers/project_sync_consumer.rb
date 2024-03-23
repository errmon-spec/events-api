# frozen_string_literal: true

class ProjectSyncConsumer
  include Sneakers::Worker

  from_queue :project_sync,
    routing_key: 'project.updated',
    content_type: 'application/json',
    timeout_job_after: 10.seconds.in_milliseconds,
    retry_timeout: 5.seconds.in_milliseconds,
    retry_max_times: 10

  def work(payload)
    ProjectManager.sync(payload)
    ack!
  end
end
