require 'ffi/pcap/bpf_instruction'
require 'ffi/pcap/data_link'

module FFI
  module PCap
    #
    # Structure for `pcap_compile()`, `pcap_setfilter()`, etc.
    #
    # See bpf_program struct in `pcap-bpf.h`
    #
    class BPFProgram < FFI::Struct

      include FFI::DRY::StructHelper

      dsl_layout do
        field    :bf_len,  :uint
        field    :bf_insn, :pointer
      end

      def instructions
        i = 0
        sz = BPFInstruction.size

        Array.new(self.bf_len) do 
          ins = BPFInstruction.new( self[:bf_insn] + i )
          i += sz
          ins
        end
      end

      def free!
        unless @closed
          @freed = true
          PCap.pcap_freecode(self)
        end
      end

      def freed?
        @freed == true
      end

      #
      # Compiles a bpf filter without a pcap device being open. Downside is
      # no error messages are available, whereas they are when you use 
      # open_dead() and use compile() on the resulting Dead.
      #
      # @param [Hash] opts
      #   Additional options for compile
      #
      # @option opts [optional, DataLink, Integer, String, Symbol] :datalink
      #   DataLink layer type. The argument type will be resolved to a
      #   DataLink value if possible. Defaults to data-link layer type NULL.
      #
      # @option opts [optional, Integer] :snaplen
      #   The snapshot length for the filter. Defaults to SNAPLEN
      #
      # @option opts [optional, Integer] :optimize
      #   Optimization flag. 0 means don't optimize. Defaults to 1.
      #
      # @option opts [optional, Integer] :netmask
      #   A 32-bit number representing the IPv4 netmask of the network on
      #   which packets are being captured. It is only used when checking
      #   for IPv4 broadcast addresses in the filter program.
      #   Default: 0 (unspecified netmask)
      #
      # @return [BPFProgram]
      #   If no errors occur, a compiled BPFProgram is returned.
      #
      def self.compile(expr, opts={})
        datalink = (opts[:datalink] || 1)
        dl = datalink.kind_of?(DataLink) ? datalink : DataLink.new(datalink)
        slen     = (opts[:snaplen] || DEFAULT_SNAPLEN)
        optimize = (opts[:optimize] || 1)
        mask     = (opts[:netmask] || 0)

        code = new()
        r = PCap.pcap_compile_nopcap(slen, dl.value, code, expr, optimize, mask)

        raise(LibError, "pcap_compile_nopcap(): unspecified error") if r < 0
        return code
      end

    end
  end
end
