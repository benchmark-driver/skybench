require 'benchmark/output/skybench/version'

class Benchmark::Output::Skybench
  # This class requires runner to measure following fields in `Benchmark::Driver::BenchmarkResult` to show output.
  REQUIRED_FIELDS = [:real]

  # @param [Array<Benchmark::Driver::Configuration::Job>] jobs
  # @param [Array<Benchmark::Driver::Configuration::Executable>] executables
  # @param [Benchmark::Driver::Configuration::OutputOptions] options
  def initialize(jobs:, executables:, options:)
    @jobs = jobs
    @executables = executables
    @options = options
    @name_length = jobs.map { |j| j.name.size }.max
  end

  def start_warming
    # noop
  end

  # @param [String] name
  def warming(name)
    # noop
  end

  # @param [Benchmark::Driver::BenchmarkResult] result
  def warmup_stats(result)
    # noop
  end

  def start_running
    $stdout.puts 'ruby:'
    @executables.each do |executable|
      $stdout.puts "  - #{executable.name}"
    end
    $stdout.puts 'results:'
  end

  # @param [String] name
  def running(name)
    $stdout.puts "  #{name}:"
  end

  # @param [Benchmark::Driver::BenchmarkResult] result
  def benchmark_stats(result)
    $stdout.puts('    - %6.3f  ' % result.real)
  end

  def finish
    # compare is not implemented yet
  end
end
