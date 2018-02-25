require 'benchmark_driver/output/skybench/version'

class BenchmarkDriver::Output::Skybench
  # @param [BenchmarkDriver::Metrics::Type] metrics_type
  attr_writer :metrics_type

  # @param [Array<BenchmarkDriver::*::Job>] jobs
  # @param [Array<BenchmarkDriver::Config::Executable>] executables
  def initialize(jobs:, executables:)
    @jobs = jobs
    @executables = executables
  end

  def with_warmup(&block)
    # noop
    block.call
  end

  def with_benchmark(&block)
    @with_benchmark = true

    $stdout.puts 'ruby:'
    @executables.each do |executable|
      $stdout.puts "  - #{executable.name}"
    end
    $stdout.puts 'results:'

    block.call
  end

  def with_job(job, &block)
    if @with_benchmark
      $stdout.puts "  #{job.name}:"
    end
    block.call
  end

  # @param [BenchmarkDriver::Metrics] metrics
  def report(metrics)
    $stdout.puts('    - %6.3f  ' % metrics.value)
  end
end
