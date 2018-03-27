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

class CreateClientTest extends TestBase {

    clients = null;

    timer   = null;

    token = null;

    constructor(authToken) {
        clients = [];
        token   = authToken;
        timer = imp.wakeup(1, _run.bindenv(this));
    }

    function shutdown(onComplete) {
        imp.cancelwakeup(timer);
        clients = null;

        onComplete();
    }


    function _run() {

        local chance = irand(100);

        if (chance < 50) {
            _create();
        } else {
            _delete();
        }

        timer = imp.wakeup(1, _run.bindenv(this));
    }

    function _delete() {
        local len = clients.len();

        if (len > 0) {
            local index = irand(len - 1);

            print("Remove client " + index);
            clients.remove(index);
        }

    }

    function _create() {
        print("Creating client");
        base._create(token);

        clients.append(client);
    }

}
