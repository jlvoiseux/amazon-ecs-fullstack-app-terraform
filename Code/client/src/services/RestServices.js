// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

import axios from 'axios'

// Use relative URL - nginx proxies /api/* to the backend server
export default {
    async getAllProducts() {
        return await axios.get("/api/getAllProducts");
    },
}
