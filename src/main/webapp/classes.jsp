<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>班级列表</title>
<script type="text/javascript">
	var url="";
	
	 //将表单数据转为json
	function form2Json(id) {
		 
        var arr = $("#" + id).serializeArray()
        var jsonStr = "";

        jsonStr += '{';
        for (var i = 0; i < arr.length; i++) {
            jsonStr += '"' + arr[i].name + '":"' + arr[i].value + '",'
        }
        jsonStr = jsonStr.substring(0, (jsonStr.length - 1));
        jsonStr += '}'

        var json = JSON.parse(jsonStr)
        return json
    }

	
	$(function(){
		//从后台拿数据填充到表内
		$("#dg").datagrid({
				idField:"id",
				url:"classes/queryByPage",
				pageSize:20,
				//使列自动展开/收缩到合适的DataGrid宽度。
				fitColumns:true,
				
				//singleSelect为true则只允许选择一行
				//singleSelect:true,
				columns:[[
					{field:"",checkbox:true},
					{field:"id",title:"编号",width:100,align:"center"},
					{field:"name",title:"班级名称",width:100,align:"center"}
					
				]],
				toolbar:[
					{
						text:"添加按钮",
						iconCls: 'icon-add',
						handler: function(){
							add();
							}
					},
					{
						text:"修改按钮",
						iconCls: 'icon-edit',
						handler: function(){
							update();
						}
					},
					{
						text:"删除按钮",
						iconCls: 'icon-remove',
						handler: function(){
							remove();
							}
					}
				],
				pagination:true,
	  			rownumbers:true
					
		});
		
		
		 $("#submit_search").click(function () {
             $('#dg').datagrid({ 
            	 queryParams: form2Json("searchform") 
           		});   //点击搜索
         });

		 
		 /* 
		 //导入按钮的绑定事件
		 $("#insubmit").click(function(){
			 $("#in").form("submit", {
			        url:"classes/inData",
			        		
			        //在提交之前触发，返回false可以终止提交。
			        onSubmit: function(){
			        	//调用validate方法效验表单中所有的字段有效性，只有所有的字段有效才返回true
			        	return $(this).form('validate');
			        },
			        success:function(data){
			        	//接收服务器返回的json格式子字符串数据转换成json对象
			        	var result = eval('('+data+')');
			        	
			        	if(result.state==0){
							
							$.messager.alert("提示",result.msg,"info");
							$("#dg").datagrid("reload");
						}else{
							$.messager.alert("提示",result.msg,"error");
						}
			        	
			        	
			        }
				});
		 });
		 
		 //导出按钮的绑定事件
		 $("#outdata").click(function(){
			 //导出数据的ajax请求 
			 $.ajax({
				url:"classes/outData",
				type:"post",
				dataType:"json",
				success:function(result){
					if(result.state==0){
						$("#dg").datagrid("reload");
						$.messager.alert("提示信息",result.msg,"info");
					}else{
						$.messager.alert("提示信息",result.msg,"info");
					}
				}
				 
			 });
		 });
		 
		  */
	});
	
	
	
	
	//删除函数
	function remove(){
		var array = $("#dg").datagrid("getSelections");
		if(array.length==0){
			$.messager.alert("提示","请选择要删除的记录","info");
			return;
		}
		
		$.messager.confirm("提示","你要删除这"+array.length+"条记录",function(r){
			if(r){
				var ids="";
				for(var i=0;i<array.length;i++){
					ids+=array[i].id+",";
				}
				ids = ids.substring(0,ids.length-1);
				
				$.ajax({
					url:"classes/deleteMore?ids="+ids,
					type:"post",
					dataType:"json",
					success:function(result){
						if(result.state==0){
							$("#dg").datagrid("reload");
							
							$.messager.alert("提示",result.msg,"info");
						}else{
							$.messager.alert("提示",result.msg,"error");
						}
						//清除之前选中的所有行
						$("#dg").datagrid("clearSelections");
					}
				
				});
			}
		});
	}
	
	function openFormDialog(){
		
		$("#dd").dialog({
			buttons:[
				{
					text:"保存",
					iconCls: 'icon-save',
					handler: function(){
						
						save();
						}
				},{
					text:"关闭",
					iconCls: 'icon-cancel',
					handler: function(){
							$("#dd").dialog("close");
						}
				}]
		});
		
		//打开对话框
		$("#dd").dialog("open");
	}
	
	//打开添加弹框
	function add(){
		//重置表单内容
    	$('#ff').form("reset");
		//新增记录的请求地址
    	url="classes/add";
		//打开弹出框
		openFormDialog();
		//设置弹出框标题
    	$("#dd").dialog("setTitle","新增学生信息");
	}
	
	//提交数据
	function save(){
		$("#ff").form("submit", {
	        url:url,
	        		
	        //在提交之前触发，返回false可以终止提交。
	        onSubmit: function(){
	        	//调用validate方法效验表单中所有的字段有效性，只有所有的字段有效才返回true
	        	return $(this).form('validate');
	        },
	        success:function(data){
	        	//接收服务器返回的json格式子字符串数据转换成json对象
	        	var result = eval('('+data+')');
	        	
	        	if(result.state==0){
					
					$.messager.alert("提示",result.msg,"info");
					$("#dg").datagrid("reload");
				}else{
					$.messager.alert("提示",result.msg,"error");
				}
	        	
	        	//关闭弹出框
	        	$("#dd").dialog("close");
	        	
	        }
		});
	}
	

	function update(){
		var array = $("#dg").datagrid("getSelections");
		if(array.length==0){
			$.messager.alert("提示","请选择要修改的记录","info");
			return;
		}else if(array.length>1){
			$.messager.alert("提示","一次只能修改一条记录","info");
			return;
		}
		//重置表单内容
		$('#ff').form("reset");
		//修改记录的请求地址
		url="classes/update?id="+array[0].id;
		//表单填充内容
		$("#ff").form("load",array[0]);
		//打开弹出框
		openFormDialog();
		//设置弹出框标题
    	$("#dd").dialog("setTitle","修改学生信息");
	}
	
	
</script>
</head>
<body>
	<div style="height: 5%;width: 2000px">
		<form name="searchform" id="searchform" method="post" fit="true" style="float: left;">
			班级名称:<input type="text" name="qname">&nbsp;&nbsp;|
				<a id="submit_search" href="#"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">搜索</a>
		</form>
		
		<!-- 上传与下载数据表单 -->
		<form id= "in" method="post" enctype="multipart/form-data" style="float: left;">
			<input name="indata" class="easyui-filebox"  style="width:200px" data-options="buttonText:'选择要上传的文件'">	<!--   -->
			<a id="insubmit" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-large-shapes'">确定上传数据</a> 
			
			<a id="outdata" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-large-shapes'">导出数据</a>  
		</form>
	
	</div>
	
	<div style="height: 95% ;clear: both;">
		<table id="dg"  fit="true"></table>
	</div>
	
	<div id="dd" class="easyui-dialog"  style="width: 300px;text-align: center;" closed="true" >
		<form method="post" id="ff" >
			班级名称：<input type="text" id="name" name="name" class="easyui-textbox" data-options="required:true"><br/>
			
		</form>
	</div>
	
</body>
</html>