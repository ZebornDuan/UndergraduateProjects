//to sign up a match
$(".add-team").click(function () {
    which = $("#" + this.id.replace('submit', 'name')).text();
    time = "#" + this.id.replace('submit', 'deadline');
    limit = $("#" + this.id.replace('submit', 'limit')).text();
    number = $("#" + this.id.replace('submit', 'number')).text();
    if ($(this).hasClass('btn-danger')) {
        if (confirm("确定取消报名吗？")) {
            $.post('',{
                'type': 'cancel',
                'which': which,
            },function() {
                alert("取消报名成功!");
                belong = $(".active-nav").text();
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
            });
        }
        return;
    }
    size = $("#" + this.id.replace('submit', 'size')).val();
    var date = new Date($(time).text());
    var now = new Date();
    if (date < now) {
        alert("报名已截止");
        return;
    }
    if (number >= limit) {
        alert("本赛事名额已满");
        return;
    }
    // alert($(".size-comment").html());
    $(".size-comment").html(size);
    $.get('', {
        'type': 'member',
        'which': which,
    }, function (data) {
        if (data.message == 'waiting') {
            alert("您参加的队伍已经报名了该赛事，请耐心等待管理员审核！");
            return;
        }
        if (data.message == 'checked') {
            alert("您参加的队伍已成功报名该赛事，祝您好运~");
            return;
        }
        $("#leader").val(data.message);
        $("#team-motal").modal("show");
    });

    var list = new Array();
    $(".member-add").click(function () {
        if($("#member-label").val() == "") {
            alert("请输入要添加的队员");
            return;
        }

        if ($(".multiple-list").find("option").length == size) {
            alert("队伍人数已达上限！");
            return;
        } else {
            $.get('', {
                'type': 'find',
                'which': which,
                'name': $("#member-label").val(),
            }, function (data) {
                if (data.message == 'no') {
                    alert("查无此人");
                    return;
                }
                if (data.message == 'checked') {
                    alert("此人已加入该赛事的其他队伍");
                    return;
                }
                if (($.inArray(data.message, list) != -1) || data.message == $("#leader").val()) {
                    alert("不能重复添加");
                } else {
                    alert("添加队员成功");
                    list.push(data.message);
                    $(".multiple-list").append("<option>" + data.message +"</option>"); 
                }
            });
        }
    });

    $("#team-btn").click(function () {
        if (list.length == 0) {
            alert("请添加队友！");
            return;
        }

        if ($("#team-name").val() == "") {
            alert("请为你的队伍起一个名字！");
            return;
        }

        var info = {
            leader: $("#leader").val(),
            member: list,
            name: $("#team-name").val(),
        };

        $.post('',{
            'type': 'submit',
            'which': which,
            'data': JSON.stringify(info),
        }, function (data) {
            if (data.message == 'ok') {
                alert("报名成功，请等待管理员审核！");
                belong = $(".active-nav").text();
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
            }
            if (data.message == 'name') {
                alert("队伍名称已经被使用 请更换一个其他的队名！");
            }
        });

    });
});

$(".submit-btn").click(function () {
    which = $("#" + this.id.replace('submit', 'name')).text();
    time = "#" + this.id.replace('submit', 'deadline');
    limit = $("#" + this.id.replace('submit', 'limit')).text();
    number = $("#" + this.id.replace('submit', 'number')).text();
    if ($(this).hasClass('btn-danger')) {
        if (confirm("确定取消报名吗？")) {
            $.post('',{
                'type': 'cancel',
                'which': which,
            },function() {
                alert("取消报名成功!");
                belong = $(".active-nav").text();
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
            });
        }
        return;
    }
    var date = new Date($(time).text());
    var now = new Date();
    if (date < now) {
        alert("报名已截止");
        return;
    }
    if (number >= limit) {
        alert("本赛事名额已满");
        return;
    }

    $.post('', {
        'type': 'submit',
        'which': which,
    }, function (data) {
        if (data.message == 'ok') {
            alert("报名成功，请等待管理员审核！");
            belong = $(".active-nav").text();
            location.href = $(".active-menu").attr("href") + '?belong=' + belong;
            return;
        }
        if (data.message == 'waiting') {
            alert("您已经报名了该赛事，请耐心等待管理员审核！");
            return;
        }
        if (data.message == 'checked') {
            alert("您已成功报名该赛事，祝您好运~");
        }
    });
});

//to delete a match
$(".delete-btn").click(function () {
    which = $("#" + this.id.replace('delete', 'name')).text();
    panel = "#" + this.id.replace('delete', 'match-panel');
    if (confirm("确定要删除赛事--" + which + "吗？")) {
        $.post('', {
            'type': 'delete',
            'which': which,
        }, function (data) {
            if (data.message == 'ok') {
                $(panel).hide("slow");
            }
        });
    }
});

//to delete news
$(".news-del").click(function () {
    url = $("#" + this.id.replace('news-btn', 'news')).attr("href");
    panel = "#" + this.id.replace('news-btn', 'news-panel');
    if (confirm("确定要该赛事总结吗？")) {
        $.post('', {
            'type': 'delete-news',
            'url': url,
            'belong': $(".active-nav").text(),
        }, function (data) {
            if (data.message == 'ok') {
                $(panel).hide("slow");
            }
        });
    }
});


$(".csv-btn").click(function() {

which = $("#" + this.id.replace('csv', 'name')).text();
$("#excil-match").modal("show");
$(".excel-btn").click(function() {
    var item = new Array();
    for(var i = 1;i < 13;i++) {
        if ($("#checkbox--" + i).is(":checked")) {
            item.push($("#excel" + i).text());
        }
    }

    if(item.length == 0)
        alert("请至少选择一项！");
    else
        location.href = '/index?name=' + which + '&type=file&data=' + JSON.stringify(item);
});

});

$(".check-btn").click(function () {
    which = $("#" + this.id.replace('check', 'name')).text();
    var operation = $(this).hasClass("btn-warning");
    //return;
    $.post('', {
        'type': 'wait',
        'which': which,
        'todo': operation,
    }, function (data) {
        if (data.waiting.length == 0) {
            if (operation)
                alert("当前没有参赛人员！");
            else
                alert("当前没有待审核人员！");
            return;
        }
        var table = "<table class=\"table table-striped table-bordered table-hover table-check\"><thead><tr><th>#</th><th>姓名</th><th>班级</th><th>确认</th><th>否认</th></tr></thead><tbody>";
        if (data.type != 'personal')
            table = "<table class=\"table table-striped table-bordered table-hover table-check\"><thead><tr><th>#</th><th>队名</th><th>队长</th><th>确认</th><th>否认</th></tr></thead><tbody>";
        if (operation)
            table = "<table class=\"table table-striped table-bordered table-hover table-check\"><thead><tr><th>#</th><th>队名&nbsp&nbsp&nbsp&nbsp&nbsp</th><th>队长&nbsp&nbsp&nbsp</th><th>成绩</th><th>名次</th></tr></thead><tbody>";
        for (var i = 0; i < data.waiting.length; i++) {
            table += "<tr>";
            table += "<td>" + (i + 1) + "</td>";
            table += "<td id=\"checkname" + i + "\">" + data.waiting[i].name + "</td>";
            table += "<td id=\"checkclass" + i + "\">" + data.waiting[i].class_ + "</td>";
            if (operation) {
                table += "<td><label style=\"padding-left:0;\"  class=\"checkbox-inline\"><input type=\"text\" id=\"checkbox" + i;
                table += "\">&nbsp</label></td>";
                table += "<td><label style=\"padding-left:0;\"  class=\"checkbox-inline\"><input type=\"text\" id=\"refuse" + i;
                table += "\">&nbsp</label></td></tr>";
            } else {
                table += "<td><label class=\"checkbox-inline\"><input type=\"checkbox\" id=\"checkbox" + i;
                table += "\">&nbsp</label></td>";
                table += "<td><label class=\"checkbox-inline\"><input type=\"checkbox\" id=\"refuse" + i;
                table += "\">&nbsp</label></td></tr>"
            }
        }
        table += "</tbody></table>";
        $("#table-div").html(table);
        if (operation) {
            $(".confirm-btn").text("添加完成");
            $("#modal-title").text("添加成绩");
        } else {
            $(".confirm-btn").text("确认审核");
            $("#modal-title").text("人员审核");
        }
        $("#check-modal").modal("show");

        $(".confirm-btn").click(function () {
            number = $(".table-check").find("tr").length - 1;
            var list = new Array();
            var empty = false;
            if (operation) {
                for (var i  = 0;i < number;i++) {
                    var grades = $("#checkbox" + i).val()
                    var No = $("#refuse" + i).val();
                    if (grades == "")
                        empty = true;
                    var temperary = {
                        'name': $("#checkname" + i).text(),
                        'class_': $("#checkclass" + i).text(),
                        'grades': grades, 
                        'No': No,
                    }
                    list.push(temperary);
                }
            } else {
                for (var i = 0; i < number; i++) {
                    if ($("#checkbox" + i).is(":checked")) {
                        if ($("#refuse" + i).is(":checked")) {
                            alert("不能同时确认和否认");
                            return;
                        }
                        var temperary = {
                            'name': $("#checkname" + i).text(),
                            'class_': $("#checkclass" + i).text(),
                            'type': 'check',
                        };
                        list.push(temperary);
                    }

                    if ($("#refuse" + i).is(":checked")) {
                        var temperary = {
                            'name': $("#checkname" + i).text(),
                            'class_': $("#checkclass" + i).text(),
                            'type': 'refuse',
                        };
                        list.push(temperary);
                    }
                }
            }
            if (operation) {
                if (empty) {
                    alert("请补全成绩信息");
                } else {
                    $.post('', {
                        'type': 'grades',
                        'which': which,
                        'list': JSON.stringify(list),
                    }, function(data) {
                        alert("成绩添加完成！");
                        $("#check-modal").modal("hide");
                        belong = $(".active-nav").text();
                        location.href = $(".active-menu").attr("href") + '?belong=' + belong;
                        return;
                    })
                }
            } else {
                if (list.length == 0)
                    alert("请至少选择一项！");
                else {
                    $.post('', {
                        'type': 'check',
                        'which': which,
                        'list': JSON.stringify(list),
                    }, function (data) {
                        alert("审核完成！");
                        $("#check-modal").modal("hide");
                        belong = $(".active-nav").text();
                        location.href = $(".active-menu").attr("href") + '?belong=' + belong;
                        return;
                    });
                }
            }
            
        });
    });
});

// $(".label-nav").click(function () {
//     $(".active-nav").removeClass("active-nav");
//     this.addClass("active-nav");
// });

$("#add-btn").click(function () {
    $('.error_message').hide();
    name = $("#mname").val();
    address = $("#maddress").val();
    limit = $("#mlimit").val();
    deadline = $("#dtp_input1").val();
    date = $("#dtp_input2").val();
    description = $("#mdescription").val();
    team = $("#team").val();
    size = $("#teamSize").val();
    belong = $(".active-nav").text();
    if (name == "" || address == "" || date == "" || deadline == "" || description == "") {
        $('.error_message').show().text("请补全赛事信息");
        return;
    }
    if (isNaN(limit) || limit < 1) {
        $('.error_message').show().text("请用大于0的数字填写人数限制");
        return;
    }

    if (team == "团体" && (isNaN(size) || size < 1)) {
        $('.error_message').show().text("请用大于0的数字填写队伍人数限制");
        return;
    }

    $.post('', {
        'type': 'add',
        'which': belong,
        'name': name,
        'address': address,
        'limit': limit,
        'date': date,
        'deadline': deadline,
        'team': team,
        'size': size,
        'description': description,
    }, function (data) {
        if (data.message == 'ok') {
            alert("添加赛事成功！");
            $("#add-match").hide("slow");
            setTimeout(function () {
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
            }, 500);
        }
        if (data.message == 'used') {
            alert("该赛事已存在，请重新确认或更换赛事名称！");
        }
    });
});

$("#edit-url").click(function () {
    if ($("#news-title").val() == "" || $("#news-url").val() == "") {
        $('.error_message').show().text("请补全赛事总结信息");
        setTimeout(function () {
                $('.error_message').hide("slow");
        }, 500);
        return;
    }
    $("#url-form").submit();

});


$("#edit-btn").click(function () {
    if ($("#picture").val() == "") {
        $('.error_message').show().text("请选择一张图片！");
        setTimeout(function () {
            $(".error_message").hide("slow");
        }, 500);
        return;
    }
    $("#file-form").submit();
});

function validate_img(img, id) {
    var file = img.value;
    if (((img.files[0].size).toFixed(2)) >= (2 * 1024 * 1024)) {
        alert("请上传小于2M的图片");
        $(id).val("");
        return false;
    }
    if (!/.(gif|jpg|jpeg|png|GIF|JPG|bmp)$/.test(file)) {
        alert("图片类型必须是.gif,jpeg,jpg,png,bmp中的一种");
        $(id).val("");
        return false;
    } else {
        if (((img.files[0].size).toFixed(2)) >= (2 * 1024 * 1024)) {
            alert("请上传小于2M的图片");
            $(id).val("");
            return false;
        }
    }
};

function isTeam(selector) {
    var value = selector.value;
    if (value == '团体') {
        $("#teamDiv").show();
    }

    else {
        $("#teamDiv").hide();
    }
};

$('.form_date').datetimepicker({
    language: 'zh-CN',
    weekStart: 1,
    todayBtn: 1,
    autoclose: 1,
    todayHighlight: 1,
    startView: 2,
    minView: 2,
    forceParse: 0
});


$(".labeladd").click(function() {
    label = $("#label-belong").val();
    if (label == '') {
        alert("请输入要添加的内容");
    }
    else {
        $.get('',{
            'type': 'label-add',
            'value': label,
        }, function(data) {
            if (data.message == 'exist')
                alert("该项目已存在")
            else {
                belong = $(".active-nav").text();
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
                return;
            }
        })
    }
});


$(".labeldelete").click(function() {
    label = $("#label-belong").val();
    if (label == "")
        alert("请输入要删除的内容");
    else {
        $.get('',{
            'type': 'label-delete',
            'value': label,
        }, function(data) {
            if (data.message == 'exist')
                alert("该项目不存在")
            else {
                belong = $(".active-nav").text();
                location.href = $(".active-menu").attr("href") + '?belong=' + belong;
                return;
            }
        })
    }
});