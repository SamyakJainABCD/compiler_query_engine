; ModuleID = 'test_vulnerable_code.c'
source_filename = "test_vulnerable_code.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"Copied: %s\0A\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.2 = private unnamed_addr constant [15 x i8] c"Full Name: %s\0A\00", align 1
@.str.3 = private unnamed_addr constant [20 x i8] c"Data: %s, Value: %d\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"Enter username: \00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.7 = private unnamed_addr constant [14 x i8] c"Username: %s\0A\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"%s-%s\00", align 1
@.str.9 = private unnamed_addr constant [12 x i8] c"Result: %s\0A\00", align 1
@.str.10 = private unnamed_addr constant [8 x i8] c"%s = %s\00", align 1
@.str.11 = private unnamed_addr constant [20 x i8] c"Key: %s, Value: %s\0A\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"%02X \00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@global_buffer = dso_local global [40 x i8] zeroinitializer, align 16
@.str.14 = private unnamed_addr constant [12 x i8] c"Global: %s\0A\00", align 1
@.str.15 = private unnamed_addr constant [26 x i8] c"SELECT * FROM %s WHERE %s\00", align 1
@.str.16 = private unnamed_addr constant [11 x i8] c"Query: %s\0A\00", align 1
@.str.17 = private unnamed_addr constant [20 x i8] c"Copied %d elements\0A\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"Path: %s\0A\00", align 1
@.str.20 = private unnamed_addr constant [15 x i8] c"User input: %s\00", align 1
@.str.21 = private unnamed_addr constant [42 x i8] c"========================================\0A\00", align 1
@.str.22 = private unnamed_addr constant [42 x i8] c"Vulnerable C Code - Buffer Overflow Test\0A\00", align 1
@.str.23 = private unnamed_addr constant [43 x i8] c"========================================\0A\0A\00", align 1
@.str.24 = private unnamed_addr constant [16 x i8] c"Test 1: strcpy\0A\00", align 1
@.str.25 = private unnamed_addr constant [15 x i8] c"This is a test\00", align 1
@.str.26 = private unnamed_addr constant [17 x i8] c"\0ATest 2: strcat\0A\00", align 1
@.str.27 = private unnamed_addr constant [5 x i8] c"John\00", align 1
@.str.28 = private unnamed_addr constant [4 x i8] c"Doe\00", align 1
@.str.29 = private unnamed_addr constant [18 x i8] c"\0ATest 3: sprintf\0A\00", align 1
@.str.30 = private unnamed_addr constant [10 x i8] c"test data\00", align 1
@.str.31 = private unnamed_addr constant [16 x i8] c"\0ATest 4: scanf\0A\00", align 1
@.str.32 = private unnamed_addr constant [28 x i8] c"(Skipped - requires input)\0A\00", align 1
@.str.33 = private unnamed_addr constant [29 x i8] c"\0ATest 5: Multiple overflows\0A\00", align 1
@.str.34 = private unnamed_addr constant [6 x i8] c"Data1\00", align 1
@.str.35 = private unnamed_addr constant [6 x i8] c"Data2\00", align 1
@.str.36 = private unnamed_addr constant [17 x i8] c"\0ATest 7: sscanf\0A\00", align 1
@.str.37 = private unnamed_addr constant [12 x i8] c"key = value\00", align 1
@.str.38 = private unnamed_addr constant [25 x i8] c"\0ATest 8: strncpy issues\0A\00", align 1
@.str.39 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.40 = private unnamed_addr constant [23 x i8] c"\0ATest 9: Network data\0A\00", align 1
@.str.41 = private unnamed_addr constant [4 x i8] c"\01\02\03\00", align 1
@.str.42 = private unnamed_addr constant [25 x i8] c"\0ATest 10: Global buffer\0A\00", align 1
@.str.43 = private unnamed_addr constant [12 x i8] c"global data\00", align 1
@.str.44 = private unnamed_addr constant [26 x i8] c"\0ATest 11: Query building\0A\00", align 1
@.str.45 = private unnamed_addr constant [6 x i8] c"users\00", align 1
@.str.46 = private unnamed_addr constant [7 x i8] c"id = 1\00", align 1
@.str.47 = private unnamed_addr constant [21 x i8] c"\0ATest 13: File path\0A\00", align 1
@.str.48 = private unnamed_addr constant [11 x i8] c"/home/user\00", align 1
@.str.49 = private unnamed_addr constant [9 x i8] c"file.txt\00", align 1
@.str.50 = private unnamed_addr constant [30 x i8] c"\0ATest 15: Partial mitigation\0A\00", align 1
@.str.51 = private unnamed_addr constant [13 x i8] c"partial test\00", align 1
@.str.52 = private unnamed_addr constant [43 x i8] c"\0A========================================\0A\00", align 1
@.str.53 = private unnamed_addr constant [17 x i8] c"Tests completed\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @vulnerable_strcpy(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [32 x i8], align 16
  store ptr %0, ptr %2, align 8
  %4 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0
  %5 = load ptr, ptr %2, align 8
  %6 = call ptr @strcpy(ptr noundef %4, ptr noundef %5) #4
  %7 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %7)
  ret void
}

; Function Attrs: nounwind
declare ptr @strcpy(ptr noundef, ptr noundef) #1

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @vulnerable_strcat(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca [20 x i8], align 16
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %7 = load ptr, ptr %3, align 8
  %8 = call ptr @strcpy(ptr noundef %6, ptr noundef %7) #4
  %9 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %10 = call ptr @strcat(ptr noundef %9, ptr noundef @.str.1) #4
  %11 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %12 = load ptr, ptr %4, align 8
  %13 = call ptr @strcat(ptr noundef %11, ptr noundef %12) #4
  %14 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %15 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, ptr noundef %14)
  ret void
}

; Function Attrs: nounwind
declare ptr @strcat(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @vulnerable_sprintf(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca [50 x i8], align 16
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %6 = getelementptr inbounds [50 x i8], ptr %5, i64 0, i64 0
  %7 = load ptr, ptr %3, align 8
  %8 = load i32, ptr %4, align 4
  %9 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %6, ptr noundef @.str.3, ptr noundef %7, i32 noundef %8) #4
  %10 = getelementptr inbounds [50 x i8], ptr %5, i64 0, i64 0
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef %10)
  ret void
}

; Function Attrs: nounwind
declare i32 @sprintf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @vulnerable_scanf() #0 {
  %1 = alloca [16 x i8], align 16
  %2 = call i32 (ptr, ...) @printf(ptr noundef @.str.5)
  %3 = getelementptr inbounds [16 x i8], ptr %1, i64 0, i64 0
  %4 = call i32 (ptr, ...) @__isoc99_scanf(ptr noundef @.str.6, ptr noundef %3)
  %5 = getelementptr inbounds [16 x i8], ptr %1, i64 0, i64 0
  %6 = call i32 (ptr, ...) @printf(ptr noundef @.str.7, ptr noundef %5)
  ret void
}

declare i32 @__isoc99_scanf(ptr noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @process_user_data(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca [20 x i8], align 16
  %6 = alloca [20 x i8], align 16
  %7 = alloca [30 x i8], align 16
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %8 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %9 = load ptr, ptr %3, align 8
  %10 = call ptr @strcpy(ptr noundef %8, ptr noundef %9) #4
  %11 = getelementptr inbounds [20 x i8], ptr %6, i64 0, i64 0
  %12 = load ptr, ptr %4, align 8
  %13 = call ptr @strcpy(ptr noundef %11, ptr noundef %12) #4
  %14 = getelementptr inbounds [30 x i8], ptr %7, i64 0, i64 0
  %15 = getelementptr inbounds [20 x i8], ptr %5, i64 0, i64 0
  %16 = getelementptr inbounds [20 x i8], ptr %6, i64 0, i64 0
  %17 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %14, ptr noundef @.str.8, ptr noundef %15, ptr noundef %16) #4
  %18 = getelementptr inbounds [30 x i8], ptr %7, i64 0, i64 0
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.9, ptr noundef %18)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @parse_config(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [30 x i8], align 16
  %4 = alloca [30 x i8], align 16
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds [30 x i8], ptr %3, i64 0, i64 0
  %7 = getelementptr inbounds [30 x i8], ptr %4, i64 0, i64 0
  %8 = call i32 (ptr, ptr, ...) @__isoc99_sscanf(ptr noundef %5, ptr noundef @.str.10, ptr noundef %6, ptr noundef %7) #4
  %9 = getelementptr inbounds [30 x i8], ptr %3, i64 0, i64 0
  %10 = getelementptr inbounds [30 x i8], ptr %4, i64 0, i64 0
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.11, ptr noundef %9, ptr noundef %10)
  ret void
}

; Function Attrs: nounwind
declare i32 @__isoc99_sscanf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @risky_strncpy_usage(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [16 x i8], align 16
  store ptr %0, ptr %2, align 8
  %4 = getelementptr inbounds [16 x i8], ptr %3, i64 0, i64 0
  %5 = load ptr, ptr %2, align 8
  %6 = call ptr @strncpy(ptr noundef %4, ptr noundef %5, i64 noundef 20) #4
  %7 = getelementptr inbounds [16 x i8], ptr %3, i64 0, i64 0
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %7)
  ret void
}

; Function Attrs: nounwind
declare ptr @strncpy(ptr noundef, ptr noundef, i64 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @process_network_data(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [64 x i8], align 16
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %5 = getelementptr inbounds [64 x i8], ptr %3, i64 0, i64 0
  %6 = load ptr, ptr %2, align 8
  %7 = call ptr @strcpy(ptr noundef %5, ptr noundef %6) #4
  store i32 0, ptr %4, align 4
  br label %8

8:                                                ; preds = %21, %1
  %9 = load i32, ptr %4, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds [64 x i8], ptr %3, i64 0, i64 0
  %12 = call i64 @strlen(ptr noundef %11) #5
  %13 = icmp ult i64 %10, %12
  br i1 %13, label %14, label %24

14:                                               ; preds = %8
  %15 = load i32, ptr %4, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [64 x i8], ptr %3, i64 0, i64 %16
  %18 = load i8, ptr %17, align 1
  %19 = zext i8 %18 to i32
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str.12, i32 noundef %19)
  br label %21

21:                                               ; preds = %14
  %22 = load i32, ptr %4, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, ptr %4, align 4
  br label %8, !llvm.loop !6

24:                                               ; preds = %8
  %25 = call i32 (ptr, ...) @printf(ptr noundef @.str.13)
  ret void
}

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strlen(ptr noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @fill_global_buffer(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = call ptr @strcpy(ptr noundef @global_buffer, ptr noundef %3) #4
  %5 = call i32 (ptr, ...) @printf(ptr noundef @.str.14, ptr noundef @global_buffer)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @build_query(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca [100 x i8], align 16
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = getelementptr inbounds [100 x i8], ptr %5, i64 0, i64 0
  %7 = load ptr, ptr %3, align 8
  %8 = load ptr, ptr %4, align 8
  %9 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %6, ptr noundef @.str.15, ptr noundef %7, ptr noundef %8) #4
  %10 = getelementptr inbounds [100 x i8], ptr %5, i64 0, i64 0
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.16, ptr noundef %10)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @copy_array_unsafe(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca [10 x i32], align 16
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %6, align 4
  br label %7

7:                                                ; preds = %20, %2
  %8 = load i32, ptr %6, align 4
  %9 = load i32, ptr %4, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %23

11:                                               ; preds = %7
  %12 = load ptr, ptr %3, align 8
  %13 = load i32, ptr %6, align 4
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds i32, ptr %12, i64 %14
  %16 = load i32, ptr %15, align 4
  %17 = load i32, ptr %6, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds [10 x i32], ptr %5, i64 0, i64 %18
  store i32 %16, ptr %19, align 4
  br label %20

20:                                               ; preds = %11
  %21 = load i32, ptr %6, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %6, align 4
  br label %7, !llvm.loop !8

23:                                               ; preds = %7
  %24 = load i32, ptr %4, align 4
  %25 = call i32 (ptr, ...) @printf(ptr noundef @.str.17, i32 noundef %24)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @build_file_path(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca [64 x i8], align 16
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %6 = getelementptr inbounds [64 x i8], ptr %5, i64 0, i64 0
  %7 = load ptr, ptr %3, align 8
  %8 = call ptr @strcpy(ptr noundef %6, ptr noundef %7) #4
  %9 = getelementptr inbounds [64 x i8], ptr %5, i64 0, i64 0
  %10 = call ptr @strcat(ptr noundef %9, ptr noundef @.str.18) #4
  %11 = getelementptr inbounds [64 x i8], ptr %5, i64 0, i64 0
  %12 = load ptr, ptr %4, align 8
  %13 = call ptr @strcat(ptr noundef %11, ptr noundef %12) #4
  %14 = getelementptr inbounds [64 x i8], ptr %5, i64 0, i64 0
  %15 = call i32 (ptr, ...) @printf(ptr noundef @.str.19, ptr noundef %14)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @dangerous_format_output(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [256 x i8], align 16
  store ptr %0, ptr %2, align 8
  %4 = getelementptr inbounds [256 x i8], ptr %3, i64 0, i64 0
  %5 = load ptr, ptr %2, align 8
  %6 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %4, ptr noundef @.str.20, ptr noundef %5) #4
  %7 = getelementptr inbounds [256 x i8], ptr %3, i64 0, i64 0
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef %7)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @partially_safe_copy(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca [32 x i8], align 16
  store ptr %0, ptr %2, align 8
  %4 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0
  %5 = load ptr, ptr %2, align 8
  %6 = call ptr @strncpy(ptr noundef %4, ptr noundef %5, i64 noundef 32) #4
  %7 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 31
  store i8 0, ptr %7, align 1
  %8 = getelementptr inbounds [32 x i8], ptr %3, i64 0, i64 0
  %9 = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %8)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  store i32 0, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  store ptr %1, ptr %5, align 8
  %6 = call i32 (ptr, ...) @printf(ptr noundef @.str.21)
  %7 = call i32 (ptr, ...) @printf(ptr noundef @.str.22)
  %8 = call i32 (ptr, ...) @printf(ptr noundef @.str.23)
  %9 = call i32 (ptr, ...) @printf(ptr noundef @.str.24)
  call void @vulnerable_strcpy(ptr noundef @.str.25)
  %10 = call i32 (ptr, ...) @printf(ptr noundef @.str.26)
  call void @vulnerable_strcat(ptr noundef @.str.27, ptr noundef @.str.28)
  %11 = call i32 (ptr, ...) @printf(ptr noundef @.str.29)
  call void @vulnerable_sprintf(ptr noundef @.str.30, i32 noundef 42)
  %12 = call i32 (ptr, ...) @printf(ptr noundef @.str.31)
  %13 = call i32 (ptr, ...) @printf(ptr noundef @.str.32)
  %14 = call i32 (ptr, ...) @printf(ptr noundef @.str.33)
  call void @process_user_data(ptr noundef @.str.34, ptr noundef @.str.35)
  %15 = call i32 (ptr, ...) @printf(ptr noundef @.str.36)
  call void @parse_config(ptr noundef @.str.37)
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str.38)
  call void @risky_strncpy_usage(ptr noundef @.str.39)
  %17 = call i32 (ptr, ...) @printf(ptr noundef @.str.40)
  call void @process_network_data(ptr noundef @.str.41)
  %18 = call i32 (ptr, ...) @printf(ptr noundef @.str.42)
  call void @fill_global_buffer(ptr noundef @.str.43)
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str.44)
  call void @build_query(ptr noundef @.str.45, ptr noundef @.str.46)
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str.47)
  call void @build_file_path(ptr noundef @.str.48, ptr noundef @.str.49)
  %21 = call i32 (ptr, ...) @printf(ptr noundef @.str.50)
  call void @partially_safe_copy(ptr noundef @.str.51)
  %22 = call i32 (ptr, ...) @printf(ptr noundef @.str.52)
  %23 = call i32 (ptr, ...) @printf(ptr noundef @.str.53)
  %24 = call i32 (ptr, ...) @printf(ptr noundef @.str.21)
  ret i32 0
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind willreturn memory(read) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
