// To parse this JSON data, do
//
//     final ticketDetail = ticketDetailFromJson(jsonString);

import 'dart:convert';

List<TicketDetail> ticketDetailFromJson(String str) => List<TicketDetail>.from(json.decode(str).map((x) => TicketDetail.fromJson(x)));
TicketDetail ticketDetailSingleFromJson(String str) => TicketDetail.fromJson(json.decode(str));

String ticketDetailToJson(List<TicketDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketDetail {
    TicketDetail({
        required this.id,
        required this.isScanned,
        required this.online,
        required this.uuid,
        required this.offlineTicket,
        required this.onlineTicket,
        required this.createdTs,
        required this.modifiedTs,
    });

    int id;
    bool isScanned;
    bool online;
    String uuid;
    OfflineTicket offlineTicket;
    dynamic onlineTicket;
    DateTime createdTs;
    DateTime modifiedTs;

    factory TicketDetail.fromJson(Map<String, dynamic> json) => TicketDetail(
        id: json["id"],
        isScanned: json["is_scanned"],
        online: json["online"],
        uuid: json["uuid"],
        offlineTicket: OfflineTicket.fromJson(json["offline_ticket"]),
        onlineTicket: json["online_ticket"],
        createdTs: DateTime.parse(json["created_ts"]),
        modifiedTs: DateTime.parse(json["modified_ts"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_scanned": isScanned,
        "online": online,
        "uuid": uuid,
        "offline_ticket": offlineTicket.toJson(),
        "online_ticket": onlineTicket,
        "created_ts": createdTs.toIso8601String(),
        "modified_ts": modifiedTs.toIso8601String(),
    };
}

class OfflineTicket {
    OfflineTicket({
       required this.id,
       required this.number,
       required this.fine,
       required this.organization,
       required this.userEmail,
       required this.organizationName,
       required this.lineitems,
       required this.price,
       required this.issuedTs,
       required this.onlineBooking,
       required this.isScanned,
       required this.createdTs,
       required this.modifiedTs,
    });

    int id;
    String number;
    double fine;
    int organization;
    String userEmail;
    String organizationName;
    List<Lineitem> lineitems;
    double price;
    DateTime issuedTs;
    bool onlineBooking;
    bool isScanned;
    DateTime createdTs;
    DateTime modifiedTs;

    factory OfflineTicket.fromJson(Map<String, dynamic> json) => OfflineTicket(
        id: json["id"],
        number: json["number"],
        fine: json["fine"]??0,
        organization: json["organization"],
        userEmail: json["user_email"],
        organizationName: json["organization_name"],
        lineitems: List<Lineitem>.from(json["lineitems"].map((x) => Lineitem.fromJson(x))),
        price: json["price"],
        issuedTs: DateTime.parse(json["issued_ts"]),
        onlineBooking: json["online_booking"],
        isScanned: json["isScanned"],
        createdTs: DateTime.parse(json["created_ts"]),
        modifiedTs: DateTime.parse(json["modified_ts"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "fine": fine,
        "organization": organization,
        "user_email": userEmail,
        "organization_name": organizationName,
        "lineitems": List<dynamic>.from(lineitems.map((x) => x.toJson())),
        "price": price,
        "issued_ts": issuedTs.toIso8601String(),
        "online_booking": onlineBooking,
        "isScanned": isScanned,
        "created_ts": createdTs.toIso8601String(),
        "modified_ts": modifiedTs.toIso8601String(),
    };
}

class Lineitem {
    Lineitem({
        required this.id,
        required this.subcategoryName,
        required this.type,
        required this.subcategoryPrice,
        required this.category,
        required this.quantity,
        required this.price,
        required this.createdTs,
        required this.modifiedTs,
    });

    int id;
    String subcategoryName;
    String type;
    double subcategoryPrice;
    String category;
    int quantity;
    double price;
    DateTime createdTs;
    DateTime modifiedTs;

    factory Lineitem.fromJson(Map<String, dynamic> json) => Lineitem(
        id: json["id"],
        subcategoryName: json["subcategory_name"],
        type: json["type"],
        subcategoryPrice: json["subcategory_price"],
        category: json["category"],
        quantity: json["quantity"],
        price: json["price"],
        createdTs: DateTime.parse(json["created_ts"]),
        modifiedTs: DateTime.parse(json["modified_ts"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subcategory_name": subcategoryName,
        "type": type,
        "subcategory_price": subcategoryPrice,
        "category": category,
        "quantity": quantity,
        "price": price,
        "created_ts": createdTs.toIso8601String(),
        "modified_ts": modifiedTs.toIso8601String(),
    };
}
