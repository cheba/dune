require 'dune/stanzas/iq'

module Dune
  module Stanzas
    # This stanza is described in RFC 3921.
    # Section 1.4 of RFC 6121 states that this stanza is unnecessary but MAY be
    # implemented for backward compatibility.
    # Despite not being advertised in the server features libpurple still
    # request formal session establishment and refuses to proceed without
    # receiving a response.
    class SetSession < IQ

      matcher -> n {
        n.name == 'iq' && n['type'] == 'set' && n.xpath('ns:session', 'ns' => NAMESPACES[:session]).any?
      }

       def response
        iq 'result'
      end
    end
  end
end
