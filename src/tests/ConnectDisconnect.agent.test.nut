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

class ConnectDisconnectTest extends TestBase {

    constructor(authToken) {
        _create(authToken);

        imp.wakeup(1, _run.bindenv(this));
    }

    function _run() {
        print("Connecting....");
        client.connect(_onconnected.bindenv(this), options);
    }

    function _disconnected() {
        print("Disconnected");
    }

    function _onconnected(rc, info) {
        print("OnConnected " + rc + ":" + info);

        if (rc == 0) {
            _disconnect();
        } else {
            print("Critical error. Test aborted");
        }
    }

    function _disconnect() {
        print("Disconnecting...");
        client.disconnect(_disconnected.bindenv(this));

        // try to avoid IP address ban
        imp.wakeup(::irand(10), _run.bindenv(this));
    }

    function _typeof() {
        return "ConnectDisconnectTest";
    }
}
