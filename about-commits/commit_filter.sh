#!/bin/bash

# 提示用户输入起始和结束的commit标题
read -p "Enter the start commit title (e.g., Linux aaa): " start_title
read -p "Enter the end commit title (e.g., Linux bbb): " end_title

# 获取起始和结束commit的commit-id
start_commit=$(git log --grep="$start_title" --format="%H" -n 1)
end_commit=$(git log --grep="$end_title" --format="%H" -n 1)

if [ -z "$start_commit" ]; then
  echo "Start commit not found!"
  exit 1
fi

if [ -z "$end_commit" ]; then
  echo "End commit not found!"
  exit 1
fi

# 提取在指定commit区间的commit信息
commits=$(git log $start_commit..$end_commit --oneline --grep='riscv\|RISCV\|risc-v\|RISC-V')

# 如果没有符合条件的commit，直接退出
if [ -z "$commits" ]; then
  echo "No commits found with the specified keywords in the given range!"
  exit 0
fi

# 创建一个临时文件来保存commit信息
temp_file=$(mktemp)

# 根据邮箱信息进行归类并统计提交数量
echo "$commits" | while read -r line; do
  commit_id=$(echo $line | awk '{print $1}')
  email=$(git show -s --format='%ae' $commit_id)
  echo $email >> $temp_file
done

# 使用awk处理临时文件，并根据域名统计提交数量
awk -F '@' '{print $2}' $temp_file | sort | uniq -c | sort -nr > company_commit_count.txt

# 输出结果
cat company_commit_count.txt

# 删除临时文件
rm $temp_file

