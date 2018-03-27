// MIT License
//
// Copyright 2018 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

class Device2CloudTest extends TestBase {

    constructor(authToken) {
        _create(authToken);

        imp.wakeup(1, _connect.bindenv(this));
    }

    function _send() {

        if (client == null) return;

        local retry = 10;

        local rand = ::irand(MAX_MESSAGE_SIZE);

        while (true) {
            try {
                local body = blob(rand).tostring();
                local message = client.createmessage(device2cloud_url, body);

                rand = ::irand(100);
                if (rand < 50) {
                    local id = message.sendsync();
                } else {
                    local id = message.sendasync(_onSend.bindenv(this));
                }
                print("Message was sent");

                // send next at once?
                local sendNext = ::irand(100) > 50;
                if (!sendNext)  break;

                print("Sending next immediately");
            } catch (e) {
                if (e.find("cannot create blob") != null && retry > 0) {

                    retry--;

                    rand = rand / 2;
                    continue;
                }

                print("Critical error at " + this + ". Exception " + e);
                break;
            }
        }
    }

    function _onSend(messId, rc) {
        print("_onSend: " + messId + " rc=" + rc);
    }

    function _ondelivery(messages) {
        // test was closed
        if (client == null) return;

        print("Delivered message(s) at " + this + "[");
        foreach(id in messages)  print(id);
        print("]");

        local rand = ::irand(MESSAGE_PERIOD);
        imp.wakeup(rand, _send.bindenv(this));
    }


    function _onconnected(rc, info) {
        print("OnConnected " + this + " rc=" + rc + " info=" + info);

        if (rc == 0) {
            _send();
        } else {
            print("Critical error. Test aborted");
        }
    }


    function _typeof() {
        return "Device2CloudTest";
    }
}
