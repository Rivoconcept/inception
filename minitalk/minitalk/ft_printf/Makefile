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

#*****************SOURCES****************************************

#PRINTF
PRINTF = ft_print_char.c ft_print_int.c ft_print_str.c ft_printf.c	\
	ft_print_uint.c ft_print_hexa.c ft_print_pointer.c ft_nbrlen.c

DIR_PRINTF = ./
SRC_PRINTF = $(addprefix $(DIR_PRINTF),$(PRINTF))

#LIBFT
DIR_LIBFT = ../libft
LIBFT = $(DIR_LIBFT)/libft.a

SRC = $(SRC_PRINTF)
OBJ = $(SRC:.c=.o)
CLEAN_OBJ = *.o $(DIR_LIBFT)/*.o

#****************TARGET**********************************************
NAME = libftprintf.a

#****************COMMAND**********************************************
CFLAGS = -Wall -Wextra -Werror -I $(DIR_LIBFT)
CC = cc
RM = rm -rf
AR = ar rcs

#*********************CODE********************************************

all : $(NAME)

$(NAME) : $(OBJ) $(LIBFT)
	$(AR) $(NAME) $^

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(LIBFT):
	$(MAKE) -C $(DIR_LIBFT)

clean :
	$(RM) $(CLEAN_OBJ)
	
fclean : clean
	$(RM) $(NAME) $(LIBFT)

re : fclean all

.PHONY: all clean fclean re
