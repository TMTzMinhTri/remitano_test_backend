require "grape_logging"
class Root < Grape::API
  prefix "api"
  format :json
  logger.formatter = GrapeLogging::Formatters::Default.new
  use GrapeLogging::Middleware::RequestLogger, { logger: logger, include: [GrapeLogging::Loggers::Response.new,
                                                                          GrapeLogging::Loggers::FilterParameters.new,
                                                                          GrapeLogging::Loggers::RequestHeaders.new] }
  mount V1::Base
end
