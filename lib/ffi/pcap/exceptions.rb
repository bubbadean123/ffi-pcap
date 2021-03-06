module FFI
  module PCap
    #
    # A {UnsupportedDataLinkError} indicates an invalid or
    # unsupported DataLink Layer Type (DLT) value or name.
    #
    class UnsupportedDataLinkError < StandardError
    end

    #
    # A {LibError} is used to convey errors detected by the libpcap
    # native library.
    #
    class LibError < StandardError
    end

    #
    # A {ReadError} is a sub-class of {LibError} that
    # indicates a problem reading from a pcap device.
    #
    class ReadError < LibError
    end

    class TimeoutError < LibError
    end
  end
end
