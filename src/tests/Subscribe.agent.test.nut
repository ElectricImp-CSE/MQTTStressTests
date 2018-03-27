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

@include "github:electricimp/examples/blob/master/AzureTwins/AzureTwins.agent.lib.nut"

class SubscribeTest extends AzureTwin {

    constructor(authToken) {
        base.constructor(authToken, connectionHandler.bindenv(this), twinUpdateHandler.bindenv(this));

        _debug = false;
    }

    function run() {
        local nextMethod = ::irand(100);

        if (nextMethod < 33) {
            getCurrentStatus(onCurrentStatus.bindenv(this));
        } else if (nextMethod > 66) {
            local status = { "field1" : ::irand(100) };
            updateStatus(http.jsonencode(status), onUpdateStatus.bindenv(this));
        } else {
            restart();
        }
    }

    function restart() {
        print("Resubsribing");
        local topics = ["$iothub/twin/res/#","$iothub/methods/POST/#", "$iothub/twin/PATCH/properties/desired/#"];
        try {
            _mqttclient.unsubscribe(topics);
            _state  = CONNECTED;
            _subscribe();
        } catch (e) {
            print("Can't unsubscribe: " + e);
            print("Continue as SUBSCRIBED");
            run();
        }
    }

    function onCurrentStatus(err, body) {
        print("onCurrentStatus: err=" + err);
        run();
    }

    function onUpdateStatus(err, body) {
        print("onUpdateStatus: err=" + err );
        run();
    }

    function shutdown(onComplete) {
        local gracefully = :: irand(100);

        if (gracefully) _mqttclient.disconnect();

        print ("Test " + this + " closed");

        onComplete();
    }

    function connectionHandler(state) {
        print("Twin connection status " + state);

        if (state == SUBSCRIBED) {
            run();
        }
    }

    function twinUpdateHandler(version, body) {
        print("Twin update: " + version + " : " + body);
    }

    function _typeof() {
        return "SubscribeTest";
    }
}
