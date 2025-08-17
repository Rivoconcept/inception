# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/22 08:39:35 by rhanitra          #+#    #+#              #
#    Updated: 2024/03/22 08:40:09 by rhanitra         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#*****************VARIABLES****************************************

#SERVER
MINI_SERVER = main.c 

DIR_MINI_SERVER = ./
SRC_MINI_SERVER= $(addprefix $(DIR_MINI_SERVER),$(MINI_SERVER))


#PRINTF
DIR_FT_PRINTF = ../ft_printf
FT_PRINTF = $(DIR_FT_PRINTF)/libftprintf.a

#LIBFT
DIR_LIBFT = ../libft
LIBFT = $(DIR_LIBFT)/libft.a

SRC = $(SRC_MINI_SERVER)
OBJ = $(SRC:.c=.o)

#****************TARGET**********************************************
SERVER = server

#****************COMMAND**********************************************
CFLAGS = -Wall -Wextra -Werror -g -I $(DIR_FT_PRINTF) -I $(DIR_LIBFT)
CC = gcc
RM = rm -rf
AR = ar rcs

#*********************CODE********************************************

all : $(SERVER)

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(FT_PRINTF):
	$(MAKE) -C $(DIR_FT_PRINTF)

$(SERVER) : $(OBJ) $(FT_PRINTF) $(LIBFT) 
	$(CC)  $(CFLAGS) -o $@ $^ -L$(DIR_FT_PRINTF) -lftprintf -L$(DIR_LIBFT) -lft

clean :
	$(RM) $(OBJ)
	$(MAKE) -C $(DIR_FT_PRINTF) clean
	
fclean : clean
	$(RM) $(SERVER)
	$(MAKE) -C $(DIR_FT_PRINTF) fclean

re : fclean all

.PHONY: all clean fclean re
