; ModuleID = 'my_code.c'
source_filename = "my_code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [17 x i8] c"Error occurred!\0A\00", align 1, !dbg !0
@.str.1 = private unnamed_addr constant [25 x i8] c"Negative value detected\0A\00", align 1, !dbg !7
@.str.2 = private unnamed_addr constant [12 x i8] c"Result: %d\0A\00", align 1, !dbg !12

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @error_handler() #0 !dbg !27 {
  %1 = call i32 (ptr, ...) @printf(ptr noundef @.str), !dbg !30
  call void @exit(i32 noundef 1) #5, !dbg !31
  unreachable, !dbg !31
}

declare i32 @printf(ptr noundef, ...) #1

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @process_value(i32 noundef %0, i32 noundef %1) #0 !dbg !32 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !37, metadata !DIExpression()), !dbg !38
  store i32 %1, ptr %5, align 4
  call void @llvm.dbg.declare(metadata ptr %5, metadata !39, metadata !DIExpression()), !dbg !40
  call void @llvm.dbg.declare(metadata ptr %6, metadata !41, metadata !DIExpression()), !dbg !42
  store i32 0, ptr %6, align 4, !dbg !42
  %7 = load i32, ptr %4, align 4, !dbg !43
  %8 = icmp slt i32 %7, 0, !dbg !45
  br i1 %8, label %9, label %11, !dbg !46

9:                                                ; preds = %2
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str.1), !dbg !47
  store i32 -1, ptr %3, align 4, !dbg !49
  br label %14, !dbg !49

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4, !dbg !50
  %13 = mul nsw i32 %12, 2, !dbg !51
  store i32 %13, ptr %3, align 4, !dbg !52
  br label %14, !dbg !52

14:                                               ; preds = %11, %9
  %15 = load i32, ptr %3, align 4, !dbg !53
  ret i32 %15, !dbg !53
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, ptr noundef %1) #0 !dbg !54 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  call void @llvm.dbg.declare(metadata ptr %4, metadata !59, metadata !DIExpression()), !dbg !60
  store ptr %1, ptr %5, align 8
  call void @llvm.dbg.declare(metadata ptr %5, metadata !61, metadata !DIExpression()), !dbg !62
  call void @llvm.dbg.declare(metadata ptr %6, metadata !63, metadata !DIExpression()), !dbg !64
  call void @llvm.dbg.declare(metadata ptr %7, metadata !65, metadata !DIExpression()), !dbg !66
  store i32 50, ptr %7, align 4, !dbg !66
  %8 = load i32, ptr %4, align 4, !dbg !67
  %9 = icmp sgt i32 %8, 1, !dbg !69
  br i1 %9, label %10, label %15, !dbg !70

10:                                               ; preds = %2
  %11 = load ptr, ptr %5, align 8, !dbg !71
  %12 = getelementptr inbounds ptr, ptr %11, i64 1, !dbg !71
  %13 = load ptr, ptr %12, align 8, !dbg !71
  %14 = call i32 @atoi(ptr noundef %13) #6, !dbg !73
  store i32 %14, ptr %7, align 4, !dbg !74
  br label %15, !dbg !75

15:                                               ; preds = %10, %2
  %16 = load i32, ptr %7, align 4, !dbg !76
  %17 = call i32 @process_value(i32 noundef %16, i32 noundef 0), !dbg !77
  store i32 %17, ptr %6, align 4, !dbg !78
  %18 = load i32, ptr %6, align 4, !dbg !79
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %18), !dbg !80
  ret i32 0, !dbg !81
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @atoi(ptr noundef) #4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @unused() #0 !dbg !82 {
  %1 = alloca i32, align 4
  %2 = load i32, ptr %1, align 4, !dbg !85
  ret i32 %2, !dbg !85
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind willreturn memory(read) }

!llvm.dbg.cu = !{!17}
!llvm.module.flags = !{!19, !20, !21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 5, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "my_code.c", directory: "/home/samyak/CD", checksumkind: CSK_MD5, checksum: "402c61ff68674602086f8a0437b722df")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 136, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 17)
!7 = !DIGlobalVariableExpression(var: !8, expr: !DIExpression())
!8 = distinct !DIGlobalVariable(scope: null, file: !2, line: 12, type: !9, isLocal: true, isDefinition: true)
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 200, elements: !10)
!10 = !{!11}
!11 = !DISubrange(count: 25)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(scope: null, file: !2, line: 33, type: !14, isLocal: true, isDefinition: true)
!14 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 96, elements: !15)
!15 = !{!16}
!16 = !DISubrange(count: 12)
!17 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !18, splitDebugInlining: false, nameTableKind: None)
!18 = !{!0, !7, !12}
!19 = !{i32 7, !"Dwarf Version", i32 5}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{i32 8, !"PIC Level", i32 2}
!23 = !{i32 7, !"PIE Level", i32 2}
!24 = !{i32 7, !"uwtable", i32 2}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!27 = distinct !DISubprogram(name: "error_handler", scope: !2, file: !2, line: 4, type: !28, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !17)
!28 = !DISubroutineType(types: !29)
!29 = !{null}
!30 = !DILocation(line: 5, column: 5, scope: !27)
!31 = !DILocation(line: 6, column: 5, scope: !27)
!32 = distinct !DISubprogram(name: "process_value", scope: !2, file: !2, line: 9, type: !33, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !36)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !35, !35}
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !{}
!37 = !DILocalVariable(name: "val", arg: 1, scope: !32, file: !2, line: 9, type: !35)
!38 = !DILocation(line: 9, column: 23, scope: !32)
!39 = !DILocalVariable(name: "x", arg: 2, scope: !32, file: !2, line: 9, type: !35)
!40 = !DILocation(line: 9, column: 32, scope: !32)
!41 = !DILocalVariable(name: "v", scope: !32, file: !2, line: 10, type: !35)
!42 = !DILocation(line: 10, column: 9, scope: !32)
!43 = !DILocation(line: 11, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !32, file: !2, line: 11, column: 9)
!45 = !DILocation(line: 11, column: 13, scope: !44)
!46 = !DILocation(line: 11, column: 9, scope: !32)
!47 = !DILocation(line: 12, column: 9, scope: !48)
!48 = distinct !DILexicalBlock(scope: !44, file: !2, line: 11, column: 18)
!49 = !DILocation(line: 13, column: 9, scope: !48)
!50 = !DILocation(line: 19, column: 12, scope: !32)
!51 = !DILocation(line: 19, column: 16, scope: !32)
!52 = !DILocation(line: 19, column: 5, scope: !32)
!53 = !DILocation(line: 20, column: 1, scope: !32)
!54 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 22, type: !55, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !36)
!55 = !DISubroutineType(types: !56)
!56 = !{!35, !35, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!59 = !DILocalVariable(name: "argc", arg: 1, scope: !54, file: !2, line: 22, type: !35)
!60 = !DILocation(line: 22, column: 14, scope: !54)
!61 = !DILocalVariable(name: "argv", arg: 2, scope: !54, file: !2, line: 22, type: !57)
!62 = !DILocation(line: 22, column: 26, scope: !54)
!63 = !DILocalVariable(name: "result", scope: !54, file: !2, line: 23, type: !35)
!64 = !DILocation(line: 23, column: 9, scope: !54)
!65 = !DILocalVariable(name: "input", scope: !54, file: !2, line: 24, type: !35)
!66 = !DILocation(line: 24, column: 9, scope: !54)
!67 = !DILocation(line: 26, column: 9, scope: !68)
!68 = distinct !DILexicalBlock(scope: !54, file: !2, line: 26, column: 9)
!69 = !DILocation(line: 26, column: 14, scope: !68)
!70 = !DILocation(line: 26, column: 9, scope: !54)
!71 = !DILocation(line: 27, column: 22, scope: !72)
!72 = distinct !DILexicalBlock(scope: !68, file: !2, line: 26, column: 19)
!73 = !DILocation(line: 27, column: 17, scope: !72)
!74 = !DILocation(line: 27, column: 15, scope: !72)
!75 = !DILocation(line: 28, column: 5, scope: !72)
!76 = !DILocation(line: 30, column: 28, scope: !54)
!77 = !DILocation(line: 30, column: 14, scope: !54)
!78 = !DILocation(line: 30, column: 12, scope: !54)
!79 = !DILocation(line: 33, column: 28, scope: !54)
!80 = !DILocation(line: 33, column: 5, scope: !54)
!81 = !DILocation(line: 34, column: 5, scope: !54)
!82 = distinct !DISubprogram(name: "unused", scope: !2, file: !2, line: 37, type: !83, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !17)
!83 = !DISubroutineType(types: !84)
!84 = !{!35}
!85 = !DILocation(line: 37, column: 14, scope: !82)
