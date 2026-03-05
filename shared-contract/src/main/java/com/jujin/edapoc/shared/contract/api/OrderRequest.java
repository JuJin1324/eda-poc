package com.jujin.edapoc.shared.contract.api;

public record OrderRequest(
        String orderId,
        String productId,
        int quantity,
        String customerId
) {
}
