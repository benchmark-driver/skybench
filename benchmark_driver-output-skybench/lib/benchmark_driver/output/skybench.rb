require 'benchmark_driver/output/skybench/version'

class BenchmarkDriver::Output::Skybench
  # @param [BenchmarkDriver::Metrics::Type] metrics_type
  attr_writer :metrics_type

  # @param [Array<BenchmarkDriver::*::Job>] jobs
  # @param [Array<BenchmarkDriver::Config::Executable>] executables
  def initialize(jobs:, executables:)
    @jobs = jobs
    @executables = executables
    @result = StringIO.new
  end

  def with_warmup(&block)
    # noop
    block.call
  end

  def with_benchmark(&block)
    @with_benchmark = true
    doubly_puts "metrics_unit: #{@metrics_type.unit}"
    doubly_puts 'results:'

    block.call
  ensure
    if ENV.key?('RESULT_YAML')
      @result.rewind
      File.write(ENV['RESULT_YAML'], @result.read)
    else
      $stderr.puts "Missing $RESULT_YAML"
    end
    @result.close
  end

  def with_job(job, &block)
    if @with_benchmark
      doubly_puts "  #{job.name}:"
    end
    block.call
  end

  # @param [BenchmarkDriver::Metrics] metrics
  def report(metrics)
    doubly_puts("    #{metrics.executable.name}: %6.3f" % metrics.value)
  end

  private

  def doubly_puts(str)
    @result.puts(str)
    $stdout.puts(str)
  end
end
